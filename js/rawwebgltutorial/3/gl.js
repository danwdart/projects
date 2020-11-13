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
            `uniform vec2 uOffset;` +
            `uniform float uScale;` +
            `vec4 calc(vec2 texCoord) {`+
            `   float x = 0.0;` +
            `   float y = 0.0;` +
            `   float v = 10000.0;` +
            `   float j = 10000.0;` +
            `   for(int iteration = 0; iteration < 1000; ++iteration) { ` +
            `       float xtemp = x*x - y*y+texCoord.x;` +
            `       y = 2.0 * x*y + texCoord.y;` +
            `       x = xtemp;` +
            `       v = min(v, abs(x*x+y*y));` +
            `       j = min(j, abs(x*y));` +
            `       if(x*x+y*y >= 8.0) {` +
            `           float d = (float(iteration) - (log(log(sqrt(x*x+y*y))) / log(2.0))) / 50.0;` +
            `           v = (1.0 - v) / 2.0;` +
            `           j = (1.0 - j) / 2.0;` +
            `           return vec4(d+j,d,d+v,1);` +
            `       }` +
            `   }` +
            `   return vec4 (0, 0, 0, 1);`+
            `}`+
            `void main() {` +
            `vec2 texCoord = (gl_FragCoord.xy / uCanvasSize.xy) * 2.0 - vec2(1.0,1.0);` +
            `texCoord = texCoord * uScale + uOffset;` +
            `gl_FragColor = calc(texCoord);` +
            `}`,
        vertexPosBuffer = screenQuad(gl),
        program = createProgram(gl, vs, fs),
        offset = [-0.5, 0],
        scale = 1.35,
        actions = [],
        keyMappings = {
            '37' : `panleft`,
            '38' : `panup`,
            '39' : `panright`,
            '40' : `pandown`,
            '107' : `zoomin`,
            '109' : `zoomout`
        },
        iv = null;
    
    for (var k in keyMappings) {
        actions[keyMappings[k]] = false;
    }

    gl.clearColor(0, 0, 0, 1);
    gl.clear(gl.COLOR_BUFFER_BIT);

    gl.useProgram(program);

    program.vertexPosAttrib = gl.getAttribLocation(program, `aVertexPosition`);
    program.canvasSizeUniform = gl.getUniformLocation(program, `uCanvasSize`);
    program.offsetUniform = gl.getUniformLocation(program, `uOffset`);
    program.scaleUniform = gl.getUniformLocation(program, `uScale`);

    gl.enableVertexAttribArray(program.vertexPosAttrib);

    // pos attrib, dimensions, type
    gl.vertexAttribPointer(program.vertexPosAttrib, vertexPosBuffer.itemSize, gl.FLOAT, false, 0, 0);

    function draw() {
        offset[0] += -(actions.panleft ? scale / 25 : 0) + (actions.panright ? scale / 25 : 0);
        offset[1] += -(actions.pandown ? scale / 25 : 0) + (actions.panup ? scale / 25 : 0);
        scale = scale * (actions.zoomin ? 0.975 : 1.0) / (actions.zoomout ? 0.975 : 1.0);

        gl.uniform2f(program.canvasSizeUniform, canvas.width, canvas.height);
        gl.uniform2f(program.offsetUniform, offset[0], offset[1]);
        gl.uniform1f(program.scaleUniform, scale);
        gl.drawArrays(gl.TRIANGLE_STRIP, 0, vertexPosBuffer.numItems);
    }

    draw();

    window.onkeydown = function(e) {
        console.log(e.keyCode);
        var kc = e.keyCode.toString();
        if (keyMappings.hasOwnProperty(kc)) {
            actions[keyMappings[kc]] = true;
        }
        if (!iv) {
            iv = setInterval(function() { draw(); }, 16);
        }
    };
    
    window.onkeyup = function(e) {
        var kc = e.keyCode.toString();
        if (keyMappings.hasOwnProperty(kc)) {
            actions[keyMappings[kc]] = false;
        }
        for (var j in keyMappings) {
            if (actions[keyMappings[j]]) {
                return;
            }
        }
        clearInterval(iv);
        iv = null;
    };

}());