//
// passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~/**
 * shaderPaletteAlt
 * By Alain Galvan
 * Last Updated 22 Feb, 2014
 * Licenced for Public Domain
 */
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D texPalette;
uniform sampler2D texPaletteAlt;

const int SAMPLES = 16;


/*
 * Max, Min Functions.
 */
float maxCom(vec4 col)
{
    return max(col.r, max(col.g,col.b));
}

float minCom(vec4 col)
{
    return min(col.r, min(col.g,col.b));
}

/*
 * Returns a vec4 with components h,s,l,a.
 */
vec4 rgbToHsl(vec4 col)
{
    float maxComponent = maxCom(col);
    float minComponent = minCom(col);
    float dif = maxComponent - minComponent;
    float add = maxComponent + minComponent;
    vec4 outColor = vec4(0.0, 0.0, 0.0, col.a);
    
    if (minComponent == maxComponent)
    {
        outColor.r = 0.0;
    }
    else if (col.r == maxComponent)
    {
        outColor.r = mod(((60.0 * (col.g - col.b) / dif) + 360.0), 360.0);
    }
    else if (col.g == maxComponent)
    {
        outColor.r = (60.0 * (col.b - col.r) / dif) + 120.0;
    }
    else
    {
        outColor.r = (60.0 * (col.r - col.g) / dif) + 240.0;
    }

    outColor.b = 0.5 * add;
    
    if (outColor.b == 0.0)
    {
        outColor.g = 0.0;
    }
    else if (outColor.b <= 0.5)
    {
        outColor.g = dif / add;
    }
    else
    {
        outColor.g = dif / (2.0 - add);
    }
    
    outColor.r /= 360.0;
    
    return outColor;
}
/**
 * Returns Distance Squared of two vectors. 
*/
float sqrDistance(vec3 v, vec3 u)
{
    return (u.x-v.x)*(u.x-v.x) + (u.y-v.y)*(u.y-v.y) + (u.z-v.z)*(u.z-v.z);
}
/**
 * returns color in alt pallete closest to inputed color.
 */
vec4 colorPaletteAlt(vec4 inColor, sampler2D texPalette, sampler2D texPaletteAlt)
{
    vec4 outColor = vec4(0.0);
    float minDis = 1000.0;
    float dis = 100.0;
    if (inColor.a > 0.001)
    {
        for (int i = 0; i < SAMPLES; i++)
        {
            vec4 palleteColor = texture2D(texPalette, vec2((float(i) + 0.5) / float(SAMPLES), 0.5));
            //Map to HSL Space
            dis = sqrDistance(rgbToHsl(inColor).rgb,rgbToHsl(palleteColor).rgb);
            if (palleteColor.a > 0.001)
            {
                if (dis < minDis)
                {
                    minDis = dis;
                    outColor = texture2D(texPaletteAlt, vec2((float(i) + 0.5) / float(SAMPLES), 0.5));
                }
            }
        }
    }
    return outColor;
}
void main()
{
    vec4 inColor = (v_vColour * texture2D(gm_BaseTexture, v_vTexcoord));
    inColor = colorPaletteAlt(inColor, texPalette, texPaletteAlt);
    gl_FragColor = inColor;
}
