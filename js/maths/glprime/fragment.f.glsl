precision highp float;

uniform vec2 dim;
uniform vec2 mouse;
uniform float t;

void main()
{
    float x = gl_FragCoord.x / dim.x;
    float y = gl_FragCoord.y / dim.y;
    float mxp = mouse.x / dim.x;
    float myp = mouse.y / dim.y;
    float ms = mod(t,1000.0);
    float s = ms / 1000.0;

    gl_FragColor = vec4(mxp,myp,x*y, 1.0);
}
