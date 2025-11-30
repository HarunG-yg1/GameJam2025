class_name chase_enemy extends enemy_state_class
var name = "chase"
static var prev_grav : Vector2
func Enter():
		if enemy.statemachine.old_state is not falling_enemy and enemy.statemachine.old_state is not attack_enemy:
			prev_grav = Vector2.ZERO
		if ((enemy.player.global_position-enemy.global_position).normalized() + enemy.direction).length() <1.44:
			enemy.dir_int *= -1
		
			
func Process(_delta):
		if enemy.hp_and_stuff.hp <= 0:
			return dead_enemy
		enemy.chase_stamina -= _delta *2
		if  enemy.get_last_slide_collision() != null and (enemy.get_last_slide_collision().get_normal() - enemy.velocity.normalized()).length() > 1.5 and enemy.on_air_time == 0:
			if abs((enemy.player.global_position-enemy.global_position).normalized().y) + 0.3  <= abs((enemy.player.global_position-enemy.global_position).normalized().x) || enemy.weight_priority > 32:
					
				return jumpin_enemy
			else:
				if prev_grav == Vector2.ZERO:

					prev_grav = enemy.grav_dir
				#print("up rn")
			#	print(enemy.fish_type)
			#	print(enemy.grav_dir)
			#	print(prev_grav)
				enemy.up_direction = enemy.get_last_slide_collision().get_normal()
	
				enemy.grav_dir = -enemy.get_last_slide_collision().get_normal()
					#print("salam")
					#print(enemy.grav_dir)

		if enemy.player != null and ((enemy.player.global_position-enemy.global_position).normalized() + enemy.direction).length() <1.42 and (enemy.position - enemy.player.position).length() > 120:
			enemy.dir_int *= -1
		elif  enemy.player != null and (enemy.player.global_position-enemy.global_position).length() < 100 * enemy.scale.length() and enemy.is_on_floor():
			return attack_enemy
		enemy.move(enemy.direction,1)
		if (enemy.on_air_time >0.2) and !enemy.is_on_floor():
			
			if prev_grav != Vector2.ZERO:

				if abs((enemy.player.global_position-enemy.global_position).normalized().y) + 0.4 >= abs((enemy.player.global_position-enemy.global_position).normalized().x):
					enemy.dir_int *= -1

			return falling_enemy
		if enemy.recharge_stamina:
			enemy.player = null

				
			return moving_enemy
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:

			return on_wave_enemy
func Exit():
		if prev_grav != Vector2.ZERO:
				
			enemy.grav_dir= prev_grav
			enemy.up_direction = -prev_grav
			enemy.velocity *= 0
		#	prev_grav = Vector2.ZERO
		#	print("fallin rn")
		#	print(enemy.fish_type)
		#	print(enemy.grav_dir)
