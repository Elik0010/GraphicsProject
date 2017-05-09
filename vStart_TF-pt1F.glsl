attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec4 color;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform float Shininess;

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;

    // The (displacement) vector to the light source from the vertex
    vec3 Lvec = LightPosition.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize((ModelView*vec4(vNormal, 0.0)).xyz);
    
    // ***TF: Added for pt1-F:
    // Calculate a light intensity distance-attenuation coefficient,
    // dependent on the distance d of the current vertex from the light source,
    // as per Angel & Shreiner 6th ed. pg. 269, with a,b,c modified from:
    // https://gamedev.stackexchange.com/questions/56897/glsl-light-attenuation-color-and-intensity-formula
    float a = 1.0;
    float b = 0.1;
    float c = 0.02;
    float d = length(Lvec); // distance from vertex to light source
    float distAttenCoef = 1.0/(a + b*d + c*d*d);

    // Compute terms in the Blinn-Phong illumination equation:
    vec3 ambient = AmbientProduct;
    vec3 diffuse = distAttenCoef * max(dot(L, N), 0.0) * DiffuseProduct;
    vec3 specular = distAttenCoef * pow(max(dot(N, H), 0.0), Shininess) * SpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
        specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    color.rgb = globalAmbient + ambient + diffuse + specular;
    color.a = 1.0;

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
