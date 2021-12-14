--[[
  *
        require "burn"
        object.fill.effect = "filter.custom.burn"
        object.fill.effect.startTime = system.getTimer()/1000
        object.fill.effect.duration = 2
]]

local kernel = {}

kernel.language = "glsl"
kernel.category = "filter"

kernel.name = "burn"
kernel.isTimeDependent = true

kernel.vertexData   = {
  {
    name = "duration",
    default = 0.5, 
    min = 0,
    max = 100,
    index = 0, 
  },
  {
    name = "startTime",
    default = 0.0, 
    index = 1,
  }
}
kernel.fragment =
[[
  P_COLOR vec4 ash = vec4(0, 0, 0, 1);
  P_COLOR vec4 fire = vec4(127/255, 180/255, 128/255, 0.5);
  
  P_COLOR int OCTAVES = 6;

  P_COLOR float rand(vec2 coord){
    return fract(sin(dot(coord, vec2(12.9898, 78.233)))* 43758.5453123);
  }
  
  P_COLOR float noise(vec2 coord){
    P_COLOR vec2 i = floor(coord);
    P_COLOR vec2 f = fract(coord);

    P_COLOR float a = rand(i);
    P_COLOR float b = rand(i + vec2(1.0, 0.0));
    P_COLOR float c = rand(i + vec2(0.0, 1.0));
    P_COLOR float d = rand(i + vec2(1.0, 1.0));
  
    P_COLOR vec2 cubic = f * f * (3.0 - 2.0 * f);
  
    return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
  }
  
  P_COLOR float fbm(vec2 coord){
    P_COLOR float value = 0.0;
    P_COLOR float scale = 0.5;
  
    for(int i = 0; i < OCTAVES; i++){
      value += noise(coord) * scale;
      coord *= 2.0;
      scale *= 0.5;
    }
    return value;
  }
  
    P_COLOR vec4 FragmentKernel( P_UV vec2 texCoord )
    {
        P_DEFAULT float totalTime = 0.0; 

        P_COLOR vec4 color = texture2D( CoronaSampler0, texCoord );
        P_COLOR vec4 tex = texture2D( CoronaSampler0, texCoord);
        
        P_COLOR float noise = fbm(texCoord * 6.0);
        P_COLOR float thickness = 0.1;
        
        P_COLOR float outer_edge = (CoronaTotalTime - CoronaVertexUserData.y)/CoronaVertexUserData.x;
        P_COLOR float inner_edge = outer_edge + thickness;

        if (noise < inner_edge) {
          P_COLOR float grad_factor = (inner_edge - noise) / thickness;
          grad_factor = clamp(grad_factor, 0.0, 1.0);
          P_COLOR vec4 fire_grad = mix(fire, ash, grad_factor);
            
          P_COLOR float inner_fade = (inner_edge - noise) / 0.02;
          inner_fade = clamp(inner_fade, 0.0, 1.0);
            
          color = mix(color, fire_grad, inner_fade);
        }

        if (noise < outer_edge) {
          color.a = 1 - (outer_edge - noise)/ 0.03;
          color.a = clamp(color.a, 0.0, 1.0);
        }
        
        color.a *= tex.a;
        
        return CoronaColorScale(color);
      }
]]

graphics.defineEffect( kernel )