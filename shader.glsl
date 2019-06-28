uniform int objects = 0;
uniform vec2 positions[50];
uniform float radii[50];
uniform float meter = 64;
varying vec2 texPos;
uniform vec2 cameraPosition;
uniform float k1 = sqrt(2*50*50); //smoothness of cells
uniform float k2 = sqrt(2*50*50)/4; //smoothness of cell walls
uniform float lineWidth = 6;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    texPos = (cameraPosition + vertex_position.xy);
    return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
float smin( float a, float b, float k )
{
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return mix( b, a, h ) - k*h*(1.0-h);
}

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {
  float finalmin = 0;
  float bordermin = 99999;
  int closestobj = -1;

  
  float mindist = 99999;
  for (int i = 0; i < objects; i++) {
    float dist = distance(positions[i], texPos) - radii[i];
    if (closestobj == -1 || dist < mindist) {
      mindist = dist;
      closestobj = i;
    }
  }

  for (int i = 0; i < objects; i++) {
    for (int j = 0; j < i; j++) {
      float di = distance(positions[i], texPos) - radii[i];
      float dj = distance(positions[j], texPos) - radii[j];
      float sm = smin(di, dj, k1);
      float m = min(di, dj);
      if (sm < finalmin) {
        finalmin = sm;
        if (closestobj == i || closestobj == j) {
          bordermin = min(abs(di-dj), bordermin);
        }
      }
    }
  }
  if (finalmin < 0) {
    if (smin(bordermin, abs(finalmin), k2) < lineWidth) {
    // if (bordermin < lineWidth) {
      color.a = 1;
    }

    return color;
  }
  return vec4(0);
}
#endif