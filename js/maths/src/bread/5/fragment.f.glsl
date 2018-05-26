precision highp float;

uniform vec2 vpDim;
uniform float minI;
uniform float maxI;
uniform float minR;
uniform float maxR;

void main()
{
    vec2 c = vec2(
        gl_FragCoord.x * (maxR - minR) / vpDim.x + minR,
        gl_FragCoord.y * (maxI - minI) / vpDim.y + minI
    );

    vec2 z = c;
    float it = 0.0;
    float maxIt = 2000.0;
    const int maxItt = 2000;

    for (int i = 0; i < maxItt; i++) {
        // curious... x^2 - y^2, 2xy
        z = vec2(
            z.x * z.x - z.y * z.y + c.x,
            2.0 * z.x * z.y + c.y
        );

        if (z.x * z.x + z.y * z.y > 4.0) {
            break;
        }

        it += 1.0;
    }

    if (it < maxIt) {
        gl_FragColor = vec4(it / 10.0, it / 10.0, it / 10.0, 1.0);
    }
    else {
        gl_FragColor = vec4(z, 0.0, 1.0);
    }
}
