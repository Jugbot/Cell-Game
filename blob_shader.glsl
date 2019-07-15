#pragma language glsl3
uniform int objects = 0;
// uniform vec2 positions[100];
// uniform float radii[100];
uniform sampler2D positionradii;
varying vec2 texPos;
// from 0 (most blending) to 1 (no blending)
uniform float k1 = 0.05; // blob clump boundary smoothness
uniform float k2 = 0.1; // blob wall smoothness
// higher = more blending
uniform float k3 = 30; // blob wall-boundary blending
uniform float borderWidth = 6;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    texPos = vertex_position.xy - love_ScreenSize.xy/2;
    return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
// cubic smooth min (for blending walls and boundaries)
float smin( float a, float b, float k )
{ 
    float h = max( k-abs(a-b), 0.0 )/k;
    return min( a, b ) - h*h*h*k*(1.0/6.0);
}
// I use power-based smooth min for walls and boundaries (since it is cumulative) 
/* Two-value example:
float smin( float a, float b, float k )
{
    float res = exp2( -k*a ) + exp2( -k*b );
    return -log2( res )/k;
}
*/

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {
  float mindist = 0;
  int closestobj = -1;

  float cummin = 0;
  for (int i = 0; i < objects; i++) {
    vec4 data = texelFetch(positionradii, ivec2(i, 0), 0);
    float dist = distance(data.xy, texPos) - data.z;
    cummin += exp2( -k1 * dist );
    if (closestobj == -1 || dist < mindist) {
      mindist = dist;
      closestobj = i;
    }
  }
  float finalmin = -log2( cummin )/k1;
  // discards pixels not in shape
  if (finalmin > 0) discard;

  // The next part finds whether or not the
  // fragment is a blob to blob boundary based
  // on the distance to the midpoint between. 
  // (these results are also smoothed)
  float cummin2 = 0;
  for (int j = 0; j < objects; j++) {
    if (j == closestobj) continue;
    vec4 data = texelFetch(positionradii, ivec2(j, 0), 0);
    float dist = distance(data.xy, texPos) - data.z;
    cummin2 += exp2( -k2 * abs(dist-mindist));
  }

  float bordermin = -log2( cummin2 )/k2;
  
  // blend blob-blob boundaries and edge of shape boundary
  // then check if result is under the border thickness
  if (smin(bordermin, abs(finalmin), k3) < borderWidth) {
    color.a = 1;
  }
  return color;
}
#endif