let T = 2 * Math.PI,
    canvas = document.querySelector(`canvas`),
    h,
    w,
    vpDim = [canvas.width, canvas.height],
    minI = -2.0,
    maxI = 2.0,
    minR = -2.0,
    maxR = 2.0;

let gl = canvas.getContext(`webgl`),
    loadAjax = (name) => new Promise((res, rej) => {
        let x = new XMLHttpRequest();
        x.open(`GET`, name, true);
        x.onreadystatechange = () => {
            if (4 == x.readyState) {
                if (200 !== x.status)
                    return rej(`Error loading `+name);
                return res(x.responseText);
            }
        };
        x.send();
    }),
    pVertexText = loadAjax(`vertex.v.glsl`),
    pFragmentText = loadAjax(`fragment.f.glsl`),
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
            throw new Error(`Error compiling vertex shader`);
        }

        gl.compileShader(fragmentShader);
        if (!gl.getShaderParameter(fragmentShader, gl.COMPILE_STATUS)) {
            console.log(gl.getShaderInfoLog(fragmentShader));
            throw new Error(`Error compiling fragment shader`);
        }

        let program = gl.createProgram();

        gl.attachShader(program, vertexShader);
        gl.attachShader(program, fragmentShader);

        gl.linkProgram(program);

        if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
            console.log(gl.getProgramInfoLog(program));
            throw new Error(`Error linking program`);
        }

        gl.validateProgram(program);
        if (!gl.getProgramParameter(program, gl.VALIDATE_STATUS)) {
            console.log(gl.getProgramInfoLog(program));
            throw new Error(`Error validating program`);
        }

        return program;
    },
    createProgram = (vertexText, fragmentText) => {
        let program = compileProgram(vertexText, fragmentText);

        gl.useProgram(program);

        let uniforms = {
            vpDim: gl.getUniformLocation(program, `vpDim`),
            minI: gl.getUniformLocation(program, `minI`),
            maxI: gl.getUniformLocation(program, `maxI`),
            minR: gl.getUniformLocation(program, `minR`),
            maxR: gl.getUniformLocation(program, `maxR`)
        };

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

        let vertPosAttrib = gl.getAttribLocation(program, `vPos`);
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

            gl.uniform2fv(uniforms.vpDim, vpDim);
            gl.uniform1f(uniforms.minI, minI);
            gl.uniform1f(uniforms.maxI, maxI);
            gl.uniform1f(uniforms.minR, minR);
            gl.uniform1f(uniforms.maxR, maxR);

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
        canvas.style.height = h+`px`;
        canvas.style.width = w + `px`;
        vpDim = [canvas.width, canvas.height];

        let oldRealRange = maxR - minR;
        maxR = ((maxI - minI) + minR);
        let newRealRange = maxR - minR;
        minR -= (newRealRange - oldRealRange) / 2;

        gl.viewport(0, 0, w, h);
    },
    zoom = (ev) => {
        let imRange = maxI - minI,
            newRange;
        if (0 > ev.deltaY) {
            newRange = imRange * 0.95;
        } else {
            newRange = imRange * 1.05;
        }

        let delta = newRange - imRange;

        minI -= delta / 2;
        maxI = minI + newRange;

        resize();
    },
    mousemove = (ev) => {
        if (1 !== ev.buttons) return;
        let iRange = maxI - minI,
            rRange = maxR - minR,
            di = (ev.movementY / h) * iRange,
            dr = (ev.movementX / w) * rRange;
        minI += di;
        maxI += di;
        minR -= dr;
        maxR -= dr;
    };

resize();
load();
addEventListener(`resize`, resize);
addEventListener(`wheel`, zoom);
addEventListener(`mousemove`, mousemove);
