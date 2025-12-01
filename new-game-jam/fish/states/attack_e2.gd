class_name attack_enemy2 extends attack_enemy
#const damage : int = 5
static var mark : Vector2
func Enter():
		
		enemy.animated_sprite.play("flash_yellow")
		enemy.hp_and_stuff.play_state_and_hurt_sound("res://sfx/block.mp3",0,1,1)
		damage = 3
		name = "attack2"
		attack_time =1.2
		enemy.velocity += enemy.JUMP_VELOCITY * (-enemy.grav_dir)
		
	#	enemy.velocity = (enemy.player.global_position-enemy.grav_dir*64-enemy.global_position).normalized()*enemy.JUMP_VELOCITY

		pass
func Process(_delta):
		if enemy.hp_and_stuff.hp <= 0:
			return dead_enemy
		if attack_time > 0.2:
			mark = enemy.player.global_position + enemy.player.velocity.normalized() * 16
		if (enemy.player.global_position-enemy.global_position).length() > 1 and attack_time < .4:
			if !enemy.hitting and (enemy.player.global_position-enemy.global_position).length() > 16:
				
				enemy.hitting = true
			

		if enemy.hitting:
			enemy.move((mark-(enemy.sprite.global_position)).normalized(),((mark-enemy.global_position).length())/20)

		if attack_time < .4:
			if (enemy.player.global_position-enemy.global_position).length() < 16 and !(enemy.player.hitting) and enemy.hitting and enemy.player.finish_run and enemy.player.hp_and_stuff.damaged_timer <= 0 and enemy.was_hit < 1:#and (enemy.sprite.position -enemy. player.position).length() < 400:
				print("yo")
				Playsound.get_playsound("res://sfx/SWORD SLASH SOUND EFFECT ｜ NO COPYRIGHT.mp3",enemy.position,0.67,randf_range(0.5,2),0.1)
				enemy.player.hp_and_stuff.take_damage(damage,1)
				enemy.player.velocity += enemy.velocity.normalized() * 400
			elif (enemy.player.global_position-enemy.global_position).length() < 16 and enemy.player.hitting  and enemy.hitting:
				Playsound.get_playsound("res://sfx/prry.mp3",enemy.position,0,randf_range(0.5,2),0.2)
				enemy.animated_sprite.play("flash_yellow")
				print("damn")
				enemy.hitting = false
			#enemy.velocity *= 0.2
			#return chase_enemy
			
			
		if attack_time < 0:
			return chase_enemy

		enemy.chase_stamina -= _delta
		attack_time -= _delta

		if !enemy.is_on_floor() and enemy.on_air_time > 0.2:
			enemy.velocity += enemy.get_gravity().length() * _delta * enemy.grav_dir
		if enemy.get_last_slide_collision() != null and enemy.get_last_slide_collision().get_normal() != enemy.get_floor_normal() and (enemy.get_last_slide_collision().get_normal() + enemy.velocity.normalized()).length() < 1:
			enemy.dir_int *= -1
		
			
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return on_wave_enemy
func Exit():
		enemy.hitting = false
		pass
