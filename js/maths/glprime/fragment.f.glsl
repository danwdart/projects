precision highp float;

uniform float h;
uniform float w;
uniform float t;

void main()
{
    float x = gl_FragCoord.x / w;
    float y = gl_FragCoord.y / h;
    float ms = mod(t,1000.0);
    float s = ms / 1000.0;

    gl_FragColor = vec4(mod(x*y,s),mod(s,x),mod(y,s), 1.0);
}
