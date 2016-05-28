precision mediump float;

struct DirectionalLight
{
    vec3 direction;
    vec3 intensity;
};

varying vec2 fragTexCoord;
varying vec3 fragNormal;

uniform vec3 ambientLightIntensity;
uniform DirectionalLight sun;
uniform vec3 sunlightDirection;

uniform sampler2D sampler;

void main()
{
    vec3 normSunDirection = normalize(sun.direction);
    vec3 surfaceNormal = normalize(fragNormal);

    vec4 texel = texture2D(sampler, fragTexCoord);

    vec3 lightIntensity = ambientLightIntensity + (
        sun.intensity * max(dot(surfaceNormal, normSunDirection), 0.0)
    );

    gl_FragColor = vec4(texel.rgb * lightIntensity, texel.a);
    //gl_FragColor = texture2D(sampler, fragTexCoord);
}
