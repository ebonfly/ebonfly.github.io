#ifdef GL_ES
precision highp float;
#endif


const vec4 gradientColor = vec4(0);//vec4(157.0/255.0, 157.0/255.0, 239.0/255.0, 1);
const vec4 cloudCol1 = vec4(120.0/255.0, 120.0/255.0, 182.0/255.0, 1)*vec4(1.3);
const vec4 cloudCol2 =  vec4(127.0/255.0, 127.0/255.0, 255.0/255.0, 1)*vec4(2);
const vec4 cloudCol3 = vec4(87.0/255.0, 87.0/255.0, 255.0/255.0, 1);
            
const float speed = 0.01;
const float intensity = 1.0;
            
uniform vec2 u_resolution;
uniform sampler2D u_tex0;
uniform float u_time;

void main() {

    vec2 uv = vec2(gl_FragCoord.x % u_resolution.x, gl_FragCoord.y % u_resolution.y) / u_resolution.xy;

    vec4 offsetMask = texture2D(u_tex0, uv + vec2(u_time*speed*2.0, u_time*speed*-0.05))*0.5
        + texture2D(u_tex0, uv + vec2(u_time*speed*4.15, u_time*speed*-0.025))*0.5;
    
    vec4 c2 = clamp(pow(texture2D(u_tex0, 3.0 * uv * vec2(pow(offsetMask.r, 2.0)*0.2+0.5) + vec2(u_time*speed*2.5, 0)), vec4(2.0))*1.5, vec4(0.0), vec4(1.0));

                
    vec4 c3 = clamp(pow(texture2D(u_tex0, 1.5*uv* vec2(pow(offsetMask.r, 2.0)*0.2+0.5)+ vec2(u_time*speed*3.0, 0) + float(0.5)), vec4(2.0))*1.3, vec4(0.0), vec4(1.0));
    
    
    vec4 cloudy1 = c2 * intensity * mix(cloudCol1, cloudCol2, clamp(sin(uv.y *3.14) *c2*7.0, vec4(0.0), vec4(1.0))*c2)*0.3;
    vec4 cloudy2 = c3 * intensity * mix(cloudCol1, cloudCol3, clamp(sin(uv.y *3.14) *c2*7.0, vec4(0.0), vec4(1.0))*c2)*1.5;

    vec4 cloudFinal = pow(cloudy1+cloudy2, vec4(2.0));

    gl_FragColor = mix(clamp(mix(mix(cloudCol2, cloudCol3, 0.5), cloudCol1*3.0, uv.y)*0.1 + cloudFinal, vec4(0.0), vec4(1.0)), gradientColor , pow(1.0-sin(uv.y*3.14)*sin(uv.x*3.14), 2.0)*0.5);
}
