// Get A WebGL context
var canvas = document.getElementById(`canvas`);
gl = canvas.getContext(`webgl`),
offset = [1,1];

function createProgram(vstr, fstr) {
    var program = gl.createProgram();
    var vshader = createShader(vstr, gl.VERTEX_SHADER);
    var fshader = createShader(fstr, gl.FRAGMENT_SHADER);
    gl.attachShader(program, vshader);
    gl.attachShader(program, fshader);
    gl.linkProgram(program);
    return program;
}

function createShader(str, type) {
    var shader = gl.createShader(type);
    gl.shaderSource(shader, str);
    gl.compileShader(shader);
    return shader;
}

gl.clearColor(0,0,0,1);
gl.clear(gl.COLOR_BUFFER_BIT);

function screenQuad()
{
    var vertexPosBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, vertexPosBuffer);
    var vertices = [
        -0.5, -0.5,
        0.5, -0.5,
        -0.5, 0.5,
        0.5, 0.5,
    ];
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
    vertexPosBuffer.itemSize = 2;
    vertexPosBuffer.numItems = 4;
    return vertexPosBuffer;
}

var vertexPosBuffer = screenQuad();

var vs = `attribute vec2 aVertexPosition;`+
    `uniform vec2 uOffset;`+
    `varying vec2 vTexCoord;`+
    `void main() {  vTexCoord = aVertexPosition + uOffset;`+
    `gl_Position = vec4(aVertexPosition, 0, 1); }`;

var fs = `precision mediump float;`+
    `varying vec2 vTexCoord;`+
    `void main() {  gl_FragColor = vec4(vTexCoord, 0, 1); }`;

var program = createProgram(vs,fs);
gl.useProgram(program);

program.vertexPosAttrib = gl.getAttribLocation(program, `aVertexPosition`);
program.offsetUniform = gl.getUniformLocation(program, `uOffset`);

gl.uniform2f(program.offsetUniform, offset[0], offset[1]);

gl.enableVertexAttribArray(program.vertexPosAttrib);

// pos attrib, dimensions, type
gl.vertexAttribPointer(program.vertexPosAttrib, vertexPosBuffer.itemSize, gl.FLOAT, false, 0, 0);

gl.drawArrays(gl.TRIANGLE_STRIP, 0, vertexPosBuffer.numItems);
