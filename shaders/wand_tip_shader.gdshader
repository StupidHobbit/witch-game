shader_type particles;

const float RADIUS = 0.03;
	
float rand_from_seed(in uint seed) {
  int k;
  int s = int(seed);
  if (s == 0)
    s = 305420679;
  k = s / 127773;
  s = 16807 * (s - k * 127773) - 2836 * k;
  if (s < 0)
    s += 2147483647;
  seed = uint(s);
  return float(seed % uint(65536)) / 65535.0;
}

uint hash(uint x) {
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = (x >> uint(16)) ^ x;
  return x;
}

void start() {
	uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
	uint alt_seed2 = hash(NUMBER + uint(27) + RANDOM_SEED);
	uint alt_seed3 = hash(NUMBER + uint(43) + RANDOM_SEED);
	uint alt_seed4 = hash(NUMBER + uint(111) + RANDOM_SEED);	
	
	float theta = rand_from_seed(alt_seed1) * PI * 2.;
	float phi = rand_from_seed(alt_seed2) * PI;
	COLOR = vec4(0.3, 0.5, 0.9, 1.);
	
	TRANSFORM[3].xyz = vec3(
		RADIUS * sin(phi) * cos(theta), 
		RADIUS * sin(phi) * sin(theta), 
		RADIUS * cos(phi)
	);
}

void process() {
	uint alt_seed1 = hash(NUMBER + uint(1) );
	uint alt_seed2 = hash(NUMBER + uint(27) );
	uint alt_seed3 = hash(NUMBER + uint(43) );
	VELOCITY = normalize(cross(
		normalize(vec3(rand_from_seed(alt_seed2), rand_from_seed(alt_seed2), rand_from_seed(alt_seed3))), 
		TRANSFORM[3].xyz
	)) * .09;
}
