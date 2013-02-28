-- lightrays pixeleffect demo
-- löve2d 0.8.0
-- blog.ioxu.com

fx = {}

-- adapted from Light Scattering GLSL shader by Fabien Sanglard.
-- http://fabiensanglard.net/lightScattering/index.php
fx.lightrays = love.graphics.newPixelEffect[[
extern number exposure = 1.0;
extern number decay = 1.0;
extern number density = 1.0;
extern number weight = 1.0;
extern vec2 lightPositionOnScreen= vec2(0.0,0.0);
extern number NUM_SAMPLES = 100.0 ;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec2 deltaTextCoord = vec2( texture_coords - lightPositionOnScreen.xy );
	vec2 textCoo = texture_coords.xy;
	deltaTextCoord *= 1.0 / float(NUM_SAMPLES) * density;
	float illuminationDecay = 1.0;
	vec4 cc = vec4(0.0, 0.0, 0.0, 1.0);

	for(int i=0; i < NUM_SAMPLES ; i++)
	{
		textCoo -= deltaTextCoord;
		vec4 sample = Texel( texture, textCoo );
		sample *= illuminationDecay * weight;
		cc += sample;
		illuminationDecay *= decay;
	}
	cc *= exposure;
	return cc;
}
]]
