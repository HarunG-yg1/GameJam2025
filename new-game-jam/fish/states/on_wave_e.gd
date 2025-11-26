class_name on_wave_enemy extends enemy_state_class
var name = "on_wave"
static var stun_time : float 
#	static var jumping : Vector2
func Enter():
		print("sa")
		stun_time = 3
		enemy.on_air_time = 0.1
		enemy.velocity *= 0 #dabs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x))
	#	jumping = enemy.wave.size * 10 * (-enemy.grav_dir)
		enemy.velocity += enemy.wave.size * 10 * (-enemy.grav_dir)
		
		pass
func Process(_delta):
		stun_time -= _delta
		
		if stun_time < 0:
			return falling_enemy
		if !enemy.is_on_floor() and enemy.on_air_time > 0.2:
			enemy.velocity += enemy.get_gravity()* _delta
		elif enemy.wave != null and enemy.on_air_time == 0:
			enemy.velocity += enemy.wave.size * (-enemy.grav_dir)

func Exit():
		enemy.wave_invulnerability_time = enemy.max_wave_invulnerability_time 
		
		
