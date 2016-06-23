let canvas = document.querySelector('canvas'),
    h = window.innerHeight,
    w = window.innerWidth;

canvas.height = h;
canvas.width = w;
canvas.style.height = h+'px';
canvas.style.width = w + 'px';

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
    promVertexText = loadAjax('vertex.v.glsl'),
    promFragmentText = loadAjax('fragment.f.glsl'),
    promVerticesText = loadAjax('vertices.json'),
    clear = () => {
        gl.clearColor(0, 0, 0, 1);
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    },
    createProgram = (vertexText, fragmentText, verticesText) => {
        let arrVertices = JSON.parse(verticesText),
            vertexShader = gl.createShader(gl.VERTEX_SHADER),
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

        let buffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(arrVertices), gl.STATIC_DRAW);

        let positionAttributeLocation = gl.getAttribLocation(program, 'vertPosition');
        gl.vertexAttribPointer(
            positionAttributeLocation,
            2,
            gl.FLOAT,
            gl.FALSE,
            5 * Float32Array.BYTES_PER_ELEMENT,
            0
        );
        let colorAttributeLocation = gl.getAttribLocation(program, 'vertColor');
        gl.vertexAttribPointer(
            colorAttributeLocation,
            3,
            gl.FLOAT,
            gl.FALSE,
            5 * Float32Array.BYTES_PER_ELEMENT,
            2 * Float32Array.BYTES_PER_ELEMENT
        );
        gl.enableVertexAttribArray(positionAttributeLocation);
        gl.enableVertexAttribArray(colorAttributeLocation);

        return program;
    },
    loop = (program, arrVertices) => {
        gl.useProgram(program);
        gl.drawArrays(
            gl.TRIANGLES,
            0,
            arrVertices.length / 5
        );
    },
    run = () => {
        Promise.all([
            promVertexText,
            promFragmentText,
            promVerticesText
        ]).then((res) => {
            let program = createProgram(...res);
            loop(program, JSON.parse(res[2]));
        }).catch((err) => console.log(err));
    };

run();
