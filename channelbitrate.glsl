 /*************************************************************************
* Channel Bitrate
* A Shader for setting the bitrate of the pipeline.
* [KEY: GBA: 5 bit, C64: 4 bit]
* Last Updated: Mon Aug 24 2015 @ 02:30AM EST
* By Alain Galvan (Alain.xyz)
* MIT Licence
*************************************************************************/

uniform int bitrate;

/**
* Convert input color to any bitrate.
*/
vec4 channelBitrate(vec4 incol, int bit)
{
	float bitdepth = pow(2.0, abs(float(bit)));
	vec4 outcol = floor(incol * bitdepth) /bitdepth;
	return outcol;
}