class_name attack_enemy2 extends attack_enemy
#const damage : int = 5
func Enter():
		damage = 3
		name = "attack2"
		attack_time =1
		enemy.velocity += enemy.JUMP_VELOCITY/5 * (-enemy.grav_dir)
		
	#	enemy.velocity = (enemy.player.global_position-enemy.grav_dir*64-enemy.global_position).normalized()*enemy.JUMP_VELOCITY

		pass
func Process(_delta):
		if (enemy.player.global_position-enemy.global_position).length() > 10 and attack_time < 0.4:
			enemy.hitting = true
			
			enemy.move((enemy.player.global_position-(enemy.sprite.global_position)).normalized(),((enemy.player.global_position-enemy.global_position).length())/8)
		if  (enemy.player.global_position-enemy.global_position).length() < 20:
			if enemy.hitting and enemy.player.finish_run and enemy.player.hp_and_stuff.damaged_timer <= 0 and enemy.was_hit < 0.1:#and (enemy.sprite.position -enemy. player.position).length() < 400:
				enemy.player.hp_and_stuff.take_damage(damage,1)
				enemy.player.velocity += enemy.velocity
				print((enemy.player.global_position-enemy.global_position).length())
			enemy.velocity *= 0.2
		
		enemy.chase_stamina -= _delta
		attack_time -= _delta

		if !enemy.is_on_floor() and enemy.on_air_time > 0.2:
			enemy.velocity += enemy.get_gravity()* _delta
		if enemy.get_last_slide_collision() != null and enemy.get_last_slide_collision().get_normal() != enemy.get_floor_normal() and (enemy.get_last_slide_collision().get_normal() + enemy.velocity.normalized()).length() < 1:
			enemy.dir_int *= -1
		if attack_time <=0:
			return chase_enemy
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return on_wave_enemy
func Exit():
		enemy.hitting = false
		pass
