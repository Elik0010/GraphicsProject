varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform float texScale; // ***TF: Introduced for pt1-B
uniform sampler2D texture;

void main()
{
    gl_FragColor = color * texture2D( texture, texCoord * texScale);
}
