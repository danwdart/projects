let canvas = document.querySelector(`canvas`),
    h = window.innerHeight,
    w = window.innerWidth;

canvas.height = h;
canvas.width = w;
canvas.style.height = h+`px`;
canvas.style.width = w + `px`;

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
    promVertexText = loadAjax(`vertex.v.glsl`),
    promFragmentText = loadAjax(`fragment.f.glsl`),
    promVerticesText = loadAjax(`vertices.json`),
    clear = () => {
        gl.clearColor(0, 0, 0, 1);
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    },
    draw = (arrVertices, arrIndices) => gl.drawElements(
        gl.TRIANGLES,
        arrIndices.length,
        gl.UNSIGNED_SHORT,
        0
    ),
    createProgram = (vertexText, fragmentText, verticesText) => {
        let arr = JSON.parse(verticesText),
            arrVertices = arr.vertices,
            arrIndices = arr.indices,
            vertexShader = gl.createShader(gl.VERTEX_SHADER),
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

        gl.enable(gl.DEPTH_TEST);
        gl.enable(gl.CULL_FACE);
        gl.cullFace(gl.BACK);
        gl.frontFace(gl.CCW);

        let vertexBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(arrVertices), gl.STATIC_DRAW);

        let indexBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
        gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(arrIndices), gl.STATIC_DRAW);

        let positionAttributeLocation = gl.getAttribLocation(program, `vertPosition`);
        gl.vertexAttribPointer(
            positionAttributeLocation,
            3,
            gl.FLOAT,
            gl.FALSE,
            6 * Float32Array.BYTES_PER_ELEMENT,
            0
        );
        let colorAttributeLocation = gl.getAttribLocation(program, `vertColor`);
        gl.vertexAttribPointer(
            colorAttributeLocation,
            3,
            gl.FLOAT,
            gl.FALSE,
            6 * Float32Array.BYTES_PER_ELEMENT,
            3 * Float32Array.BYTES_PER_ELEMENT
        );
        gl.enableVertexAttribArray(positionAttributeLocation);
        gl.enableVertexAttribArray(colorAttributeLocation);

        gl.useProgram(program);

        let matWorldUniformLocation = gl.getUniformLocation(program, `mWorld`),
            matViewUniformLocation = gl.getUniformLocation(program, `mView`),
            matProjUniformLocation = gl.getUniformLocation(program, `mProj`);

        let mWorld = new Float32Array(16),
            mView = new Float32Array(16),
            mProj = new Float32Array(16),
            mId = new Float32Array(16),
            mXRot = new Float32Array(16),
            mYRot = new Float32Array(16),
            mZRot = new Float32Array(16);
        mat4.identity(mWorld);
        mat4.lookAt(mView, [0, 0, -5], [0, 0, 0], [0, 1, 0]);
        mat4.perspective(mProj, Math.PI / 4, canvas.width / canvas.height, 0.1, 1000.0);
        mat4.identity(mId);

        // float vertex
        gl.uniformMatrix4fv(matWorldUniformLocation, gl.FALSE, mWorld);
        gl.uniformMatrix4fv(matViewUniformLocation, gl.FALSE, mView);
        gl.uniformMatrix4fv(matProjUniformLocation, gl.FALSE, mProj);

        let angle = 0,
            loop = () => {
                angle = performance.now() / 1000 / 6 * 2 * Math.PI;
                mat4.rotate(mYRot, mId, angle, [0, 1, 0]);
                mat4.rotate(mXRot, mId, angle / 4, [1, 0, 0]);
                mat4.mul(mWorld, mXRot, mYRot);
                gl.uniformMatrix4fv(matWorldUniformLocation, gl.FALSE, mWorld);

                clear();
                draw(arrVertices, arrIndices);

                requestAnimationFrame(loop);
            };
        loop();
    },
    load = () => {
        Promise.all([
            promVertexText,
            promFragmentText,
            promVerticesText
        ]).then((r) => createProgram(...r)).catch((err) => console.log(err));
    };

load();
