class_name chase_enemy extends enemy_state_class
var name = "chase"
func Enter():
		#if  ((enemy.position - enemy.player.position).normalized() * abs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x))).normalized().x > ((enemy.position - enemy.player.position).normalized() * abs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x))).normalized().y:
		if ((enemy.player.global_position-enemy.global_position).normalized() + enemy.direction).length() <1:
			enemy.dir_int *= -1
		#else:
		#	enemy.dir_int = ((enemy.position - enemy.player.position).normalized() * abs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x)).normalized().x) / abs((enemy.position - enemy.player.position).normalized() * abs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x)).normalized().y)
			
func Process(_delta):
		enemy.chase_stamina -= _delta *2
		if  enemy.get_last_slide_collision() != null and enemy.get_last_slide_collision().get_normal() != enemy.get_floor_normal() and (enemy.get_last_slide_collision().get_normal() + enemy.velocity.normalized()).length() < 1 and enemy.on_air_time == 0:
			return jumpin_enemy
		if enemy.player != null and ((enemy.player.global_position-enemy.global_position).normalized() + enemy.direction).length() <1 and (enemy.position - enemy.player.position).length() > 120:
			enemy.dir_int *= -1
		elif  enemy.player != null and (enemy.player.global_position-enemy.global_position).length() < 120 and enemy.is_on_floor():
			return attack_enemy
		enemy.move(enemy.direction,1)
		if  enemy.on_air_time >0.2:
			return falling_enemy
		if enemy.recharge_stamina:
			enemy.player = null
			return moving_enemy
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return on_wave_enemy
func Exit():
		#enemy.dir_int *= -1
		pass
