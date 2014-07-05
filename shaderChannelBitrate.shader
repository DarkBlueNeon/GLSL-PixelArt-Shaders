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
 * shaderChannelBitrate
 * By Alain Galvan
 * Last Updated 05 July, 2014
 * Licenced for Public Domain
 */
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int bitrate;

/**
* Convert input color to any bitrate.
*/
vec4 channelBitrate(vec4 inColor, int bit)
{
float bitDepth = pow(2.0, abs(float(bit)));
vec4 outColor = vec4(floor(inColor.r * bitDepth),floor(inColor.g * bitDepth),floor(inColor.b * bitDepth),floor(inColor.a * bitDepth)) / bitDepth;
return outColor;
}

void main()
{
    vec4 inColor = (v_vColour * texture2D(gm_BaseTexture, v_vTexcoord));
    inColor = channelBitrate(inColor,bitrate);
    gl_FragColor = inColor;
}
