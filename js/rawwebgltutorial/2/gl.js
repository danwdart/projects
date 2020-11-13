/*jslint browser: true */
(function () {
    "use strict";

    function createShader(gl, str, type) {
        var shader = gl.createShader(type);
        gl.shaderSource(shader, str);
        gl.compileShader(shader);
        return shader;
    }

    function createProgram(gl, vstr, fstr) {
        var program = gl.createProgram(),
            vshader = createShader(gl, vstr, gl.VERTEX_SHADER),
            fshader = createShader(gl, fstr, gl.FRAGMENT_SHADER);
        gl.attachShader(program, vshader);
        gl.attachShader(program, fshader);
        gl.linkProgram(program);
        return program;
    }

    function screenQuad(gl) {
        var vertexPosBuffer = gl.createBuffer(),
            vertices = [
                -1, -1,
                1, -1,
                -1, 1,
                1, 1
            ];

        gl.bindBuffer(gl.ARRAY_BUFFER, vertexPosBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
        vertexPosBuffer.itemSize = 2;
        vertexPosBuffer.numItems = 4;
        return vertexPosBuffer;
    }

    var canvas = document.getElementById(`canvas`),
        gl = canvas.getContext(`webgl`),
        vs = `attribute vec2 aVertexPosition;` +
            `void main() {` +
            `gl_Position = vec4(aVertexPosition, 0, 1);` +
            `}`,
        fs = `#ifdef GL_FRAGMENT_PRECISION_HIGH\n` +
            `precision highp float;\n` +
            `#else\n` +
            `precision mediump int;\n` +
            `#endif\n` +
            `uniform vec2 uCanvasSize;` +
            `vec4 calc(vec2 texCoord) {`+
            `   float x = 0.0; float y = 0.0;` +
            `   for(int iteration = 0; iteration < 1000; ++iteration) { ` +
            `       float xtemp = x*x - y*y+texCoord.x;` +
            `       y = 2.0 * x*y + texCoord.y;` +
            `       x = xtemp - 0.5;` +
            `       if(x*x+y*y >= 8.0) {` +
            `           float d = float(iteration)/20.0;` +
            `           return vec4(d, d, d, 1);`+
            `       }` +
            `   }` +
            `   return vec4 (0, 0, 0, 1);`+
            `}`+
            `void main() {` +
            `vec2 texCoord = (gl_FragCoord.xy / uCanvasSize.xy) * 2.0 - vec2(1.0,1.0);` +
            `gl_FragColor = calc(texCoord);` +
            `}`,
        vertexPosBuffer = screenQuad(gl),
        program = createProgram(gl, vs, fs);

    gl.clearColor(0, 0, 0, 1);
    gl.clear(gl.COLOR_BUFFER_BIT);

    gl.useProgram(program);

    program.vertexPosAttrib = gl.getAttribLocation(program, `aVertexPosition`);
    program.canvasSizeUniform = gl.getUniformLocation(program, `uCanvasSize`);

    gl.uniform2f(program.canvasSizeUniform, canvas.width, canvas.height);

    gl.enableVertexAttribArray(program.vertexPosAttrib);

    // pos attrib, dimensions, type
    gl.vertexAttribPointer(program.vertexPosAttrib, vertexPosBuffer.itemSize, gl.FLOAT, false, 0, 0);

    gl.drawArrays(gl.TRIANGLE_STRIP, 0, vertexPosBuffer.numItems);
}());