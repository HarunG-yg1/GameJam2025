class_name jumpin_enemy extends enemy_state_class

var name = "jumpin"
func Enter():
		enemy.jumping = true

		enemy.on_air_time = 0.1
		enemy.velocity *= abs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x))
		enemy.velocity += enemy.JUMP_VELOCITY * (-enemy.grav_dir)
		
		pass
func Process(_delta):
		if enemy.hp_and_stuff.hp <= 0:
			return dead_enemy

		if  enemy.on_air_time > 0.2:
			enemy.velocity += enemy.get_gravity().length() * _delta * enemy.grav_dir
		elif enemy.is_on_floor() and state_machine.inState_time > 0.2:
			
			return moving_enemy
		
		enemy.move(enemy.direction ,1)
		if  enemy.get_last_slide_collision() != null and (enemy.get_last_slide_collision().get_normal() - enemy.velocity.normalized()).length() > 1.5:
				enemy.velocity += -1 *abs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x)) * enemy.velocity
				enemy.dir_int *= -1
		if  enemy.on_air_time >0.2 and (enemy.velocity * abs(enemy.grav_dir)).length() <= 5:
			
			
			return falling_enemy
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return on_wave_enemy

func Exit():
		enemy.jumping =  false
		pass
