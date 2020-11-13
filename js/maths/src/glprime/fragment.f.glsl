#define TAU 6.28318530717958647693

precision highp float;

uniform vec2 dim;
uniform vec2 mouse;
uniform float t;

void main()
{
    float x = gl_FragCoord.x / dim.x;
    float y = gl_FragCoord.y / dim.y;
    float n = x * 2.0 - 1.0;
    float i = y * 2.0 - 1.0;
    float mxp = mouse.x / dim.x;
    float myp = mouse.y / dim.y;
    float ms = mod(t,1000.0);
    float s = ms / 1000.0;
    float rad = s * TAU;

    vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 white = vec4(1.0, 1.0, 1.0, 1.0);

    if (i * sin(rad) + cos(rad) > x * y)
        gl_FragColor = black;
    else
        gl_FragColor = white;
}
