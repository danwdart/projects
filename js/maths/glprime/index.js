let T = 2 * Math.PI,
    canvas = document.querySelector('canvas'),
    h,
    w;

let gl = canvas.getContext('webgl'),
    loadAjax = (name) => new Promise((res, rej) => {
        let x = new XMLHttpRequest();
        x.open('GET', name, true);
        x.onreadystatechange = () => {
            if (4 == x.readyState) {
                if (200 !== x.status)
                    return rej('Error loading '+name);
                return res(x.responseText);
            }
        };
        x.send();
    }),
    pVertexText = loadAjax('vertex.v.glsl'),
    pFragmentText = loadAjax('fragment.f.glsl'),
    clear = () => {
        gl.clearColor(0, 0, 0, 1);
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    },
    draw = (arrVertices) => gl.drawArrays(
        gl.TRIANGLES,
        0,
        arrVertices.length / 2
    ),
    compileProgram = (vertexText, fragmentText) => {
        let vertexShader = gl.createShader(gl.VERTEX_SHADER),
            fragmentShader = gl.createShader(gl.FRAGMENT_SHADER);

        gl.shaderSource(vertexShader, vertexText);
        gl.shaderSource(fragmentShader, fragmentText);

        gl.compileShader(vertexShader);
        if (!gl.getShaderParameter(vertexShader, gl.COMPILE_STATUS)) {
            console.log(gl.getShaderInfoLog(vertexShader));
            throw new Error('Error compiling vertex shader');
        }

        gl.compileShader(fragmentShader);
        if (!gl.getShaderParameter(fragmentShader, gl.COMPILE_STATUS)) {
            console.log(gl.getShaderInfoLog(fragmentShader));
            throw new Error('Error compiling fragment shader');
        }

        let program = gl.createProgram();

        gl.attachShader(program, vertexShader);
        gl.attachShader(program, fragmentShader);

        gl.linkProgram(program);

        if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
            console.log(gl.getProgramInfoLog(program));
            throw new Error('Error linking program');
        }

        gl.validateProgram(program);
        if (!gl.getProgramParameter(program, gl.VALIDATE_STATUS)) {
            console.log(gl.getProgramInfoLog(program));
            throw new Error('Error validating program');
        }

        return program;
    },
    createProgram = (vertexText, fragmentText) => {
        let program = compileProgram(vertexText, fragmentText);

        gl.useProgram(program);

        let vertBuf = gl.createBuffer(),
            arrVertices = [
                -1,1,
                -1,-1,
                1,-1,

                -1,1,
                1,1,
                1,-1
            ];
        gl.bindBuffer(gl.ARRAY_BUFFER, vertBuf);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(arrVertices), gl.STATIC_DRAW);

        let vertPosAttrib = gl.getAttribLocation(program, 'vPos');
        gl.vertexAttribPointer(
            vertPosAttrib,
            2, gl.FLOAT,
            gl.FALSE,
            2 * Float32Array.BYTES_PER_ELEMENT,
            0
        );
        gl.enableVertexAttribArray(vertPosAttrib);

        loop = () => {
            clear();

            gl.uniform1f(gl.getUniformLocation(program, 'h'), h);
            gl.uniform1f(gl.getUniformLocation(program, 'w'), w);
            gl.uniform1f(gl.getUniformLocation(program, 't'), performance.now());

            draw(arrVertices);

            requestAnimationFrame(loop);
        };
        loop();
    },
    load = () => {
        Promise.all([
            pVertexText,
            pFragmentText
        ]).then((r) => createProgram(...r)).catch((err) => console.log(err));
    },
    resize = (ev) => {
        h = window.innerHeight;
        w = window.innerWidth;
        canvas.height = h;
        canvas.width = w;
        canvas.style.height = h+'px';
        canvas.style.width = w + 'px';
        vpDim = [canvas.width, canvas.height];

        gl.viewport(0, 0, w, h);
    };

resize();
load();
