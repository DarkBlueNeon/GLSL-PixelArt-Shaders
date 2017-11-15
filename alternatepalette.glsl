 /*************************************************************************
* Alternate Palette
* A Shader for setting alternate palettes for sprites.
* Last Updated: Mon Aug 24 2015 @ 02:30AM EST
* By Alain Galvan (Alain.xyz)
* MIT Licence
*************************************************************************/
 
uniform sampler2D texPalette;		//Current Palette
uniform sampler2D texPaletteAlt;	//Alt Palette
const int SAMPLES = 16;			//Max Num of Colors in Palette

/*
 * Returns a vec4 with components h,s,l,a.
 */
vec4 rgbToHsl(vec4 col)
{
    float maxcom = max(col.r, max(col.g,col.b));
    float mincom = min(col.r, min(col.g,col.b));
    float dif = maxcom - mincom;
    float add = maxcom + mincom;
    vec4 outcol = vec4(0., 0., 0., col.a);
    
	//Hue
    if (mincom == maxcom)
        outcol.r = 0.0;
    else if (col.r == maxcom)
        outcol.r = mod(((60.0 * (col.g - col.b) / dif) + 360.0), 360.0);
    else if (col.g == maxcom)
        outcol.r = (60.0 * (col.b - col.r) / dif) + 120.0;
    else
        outcol.r = (60.0 * (col.r - col.g) / dif) + 240.0;
    outcol.r /= 360.0;
	//Lum
    outcol.b = 0.5 * add;
	//Sat
    if (outcol.b == 0.0)
        outcol.g = 0.0;
    else if (outcol.b <= 0.5)
        outcol.g = dif / add;
    else
        outcol.g = dif / (2.0 - add);
    return outcol;
}

/**
 * returns color in alt palette closest to inputed color.
 */
vec4 colorPaletteAlt(vec4 incol, sampler2D texPalette, sampler2D texPaletteAlt)
{
    vec4 outcol = vec4(0.0);
    float minDis = 1000.0;
    float dis = 100.0;
    if (incol.a > 0.001)
    {
        for (int i = 0; i < SAMPLES; i++)
        {
            vec4 palleteColor = texture2D(texPalette, vec2((float(i) + 0.5) / float(SAMPLES), 0.5));
            //Map to HSL Space
            dis = dot(rgbToHsl(incol).rgb,rgbToHsl(palleteColor).rgb);
            if (palleteColor.a > 0.001)
            {
                if (dis < minDis)
                {
                    minDis = dis;
                    outcol = texture2D(texPaletteAlt, vec2((float(i) + 0.5) / float(SAMPLES), 0.5));
                }
            }
        }
    }
    return outcol;
}
