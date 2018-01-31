let T = 2 * Math.PI,
    canvas = document.querySelector(`canvas`),
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
    pVertexText = loadAjax(`vertex.v.glsl`),
    pFragmentText = loadAjax(`fragment.f.glsl`),
    pVerticesText = loadAjax(`susan.json`),
    clear = () => {
        gl.clearColor(0.5, 0.5, 0.5, 1);
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    },
    draw = (arrVertices, arrIndices) => gl.drawElements(
        gl.TRIANGLES,
        arrIndices.length,
        gl.UNSIGNED_SHORT,
        0
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
    applySettings = () => {
        gl.enable(gl.DEPTH_TEST);
        gl.enable(gl.CULL_FACE);
        gl.cullFace(gl.BACK);
        gl.frontFace(gl.CCW);
    },
    enablePositionBuffer = (program, arrVertices) => {
        let posVertexBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, posVertexBuffer);
        let positionAttributeLocation = gl.getAttribLocation(program, `vertPosition`);
        gl.vertexAttribPointer(
            posVertexBuffer,
            3, gl.FLOAT,
            gl.FALSE,
            3 * Float32Array.BYTES_PER_ELEMENT,
            0
        );
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(arrVertices), gl.STATIC_DRAW);
        gl.enableVertexAttribArray(positionAttributeLocation);
    },
    enableTexCoordBuffer = (program, arrTexCoords) => {
        let texCoordBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, texCoordBuffer);
        let texCoordAttributeLocation = gl.getAttribLocation(program, `vertTexCoord`);
        gl.vertexAttribPointer(
            texCoordAttributeLocation,
            2,
            gl.FLOAT,
            gl.FALSE,
            2 * Float32Array.BYTES_PER_ELEMENT,
            0
        );
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(arrTexCoords), gl.STATIC_DRAW);
        gl.enableVertexAttribArray(texCoordAttributeLocation);
    },
    enableIndexBuffer = (program, arrIndices) => {
        let indexBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
        gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(arrIndices), gl.STATIC_DRAW);
    },
    enableNormalBuffer = (program, arrNormals) => {
        let normalBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, normalBuffer);
        let normalAttribLocation = gl.getAttribLocation(program, `vertNormal`);
        gl.vertexAttribPointer(
            normalAttribLocation,
            3, gl.FLOAT,
            gl.TRUE,
            3 * Float32Array.BYTES_PER_ELEMENT,
            0
        );
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(arrNormals), gl.STATIC_DRAW);
        gl.enableVertexAttribArray(normalAttribLocation);
    },
    enableTexture = (program, texId) => {
        let tex = gl.createTexture();
        gl.bindTexture(gl.TEXTURE_2D, tex);
        gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);

        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, document.getElementById(texId));
        gl.activeTexture(gl.TEXTURE0);
        gl.bindTexture(gl.TEXTURE_2D, null);
        return tex;
    },
    enableTransforms = (program) => {
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
        mat4.perspective(mProj, T / 8, canvas.width / canvas.height, 0.1, 1000.0);
        mat4.identity(mId);

        // float vertex
        gl.uniformMatrix4fv(matWorldUniformLocation, gl.FALSE, mWorld);
        gl.uniformMatrix4fv(matViewUniformLocation, gl.FALSE, mView);
        gl.uniformMatrix4fv(matProjUniformLocation, gl.FALSE, mProj);

        return [mXRot, mYRot, mId, mWorld, matWorldUniformLocation];
    },
    enableLights = (program) => {
        let ambientLightIntensityUniformLocation = gl.getUniformLocation(program, `ambientLightIntensity`),
            sunlightDirectionUniformLocation = gl.getUniformLocation(program, `sun.direction`),
            sunlightIntensityUniformLocation = gl.getUniformLocation(program, `sun.intensity`);

        gl.uniform3f(ambientLightIntensityUniformLocation, 0.2, 0.2, 0.2);
        gl.uniform3f(sunlightDirectionUniformLocation, 3.0, 4.0, -2.0);
        gl.uniform3f(sunlightIntensityUniformLocation, 0.9, 0.9, 0.9);
    },
    rotate = (mXRot, mYRot, mId, mWorld, matWorldUniformLocation) => {
        let angle = performance.now() / 1000 / 6 * T;
        mat4.rotate(mYRot, mId, angle, [0, 1, 0]);
        mat4.rotate(mXRot, mId, angle / 4, [1, 0, 0]);
        mat4.mul(mWorld, mXRot, mYRot);
        gl.uniformMatrix4fv(matWorldUniformLocation, gl.FALSE, mWorld);
    },
    useTexture = (tex) => {
        gl.bindTexture(gl.TEXTURE_2D, tex);
        gl.activeTexture(gl.TEXTURE0);
    },
    createProgram = (vertexText, fragmentText, verticesText) => {
        let arr = JSON.parse(verticesText),
            arrVertices = arr.meshes[0].vertices,
            arrIndices = [].concat.apply([], arr.meshes[0].faces),
            arrTexCoords = arr.meshes[0].texturecoords[0],
            arrNormals = arr.meshes[0].normals,
            program = compileProgram(vertexText, fragmentText),
            tex = enableTexture(program, `texture`);

        applySettings();
        enablePositionBuffer(program, arrVertices);
        enableTexCoordBuffer(program, arrTexCoords);
        enableIndexBuffer(program, arrIndices);
        enableNormalBuffer(program, arrNormals);
        gl.useProgram(program);

        let transforms = enableTransforms(program);
        enableLights(program);

        loop = () => {
            rotate(...transforms);

            clear();
            useTexture(tex);
            draw(arrVertices, arrIndices);

            requestAnimationFrame(loop);
        };
        loop();
    },
    load = () => {
        Promise.all([
            pVertexText,
            pFragmentText,
            pVerticesText
        ]).then((r) => createProgram(...r)).catch((err) => console.log(err));
    };

load();
