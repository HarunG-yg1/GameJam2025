class_name attack_enemy3 extends falling_enemy
static var attack_time : float
static var damage : int = 5
func Enter():
		name = "attack3"
		attack_time = 0
		#enemy.velocity *= enemy.grav_dir
		enemy.velocity += enemy.JUMP_VELOCITY* (-enemy.grav_dir)
		
	#	enemy.velocity = (enemy.player.global_position-enemy.grav_dir*64-enemy.global_position).normalized()*enemy.JUMP_VELOCITY

		pass
func Process(_delta):
		if enemy.hp_and_stuff.hp <= 0:
			return dead_enemy
		attack_time += _delta
		if attack_time > 0.75:
			enemy.move(((enemy.player.global_position-enemy.sprite.global_position)* abs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x))).normalized(),1)
		enemy.velocity += enemy.get_gravity().length() * _delta * enemy.grav_dir
		if (enemy.on_air_time >0.2  and (enemy.velocity.normalized() - enemy.grav_dir).length() < 1 ||  (enemy.velocity * abs(enemy.grav_dir)).length() <= 10):
			if !enemy.hitting:
				enemy.animated_sprite.play("flash_red")
				enemy.hp_and_stuff.play_state_and_hurt_sound("res://sfx/SUSPENSE SOUND EFFECTS.mp3",0.35,0.6,1)
			enemy.hitting = true
			
			#enemy.move((enemy.player.global_position-(enemy.global_position+(enemy.grav_dir)*32)).normalized(),((enemy.player.global_position-enemy.global_position).length())/8)
		if  (enemy.player.global_position-enemy.sprite.global_position).length() < 8 * enemy.scale.length():
			if enemy.hitting and enemy.player.finish_run and enemy.player.statemachine.state is not harpooning and enemy.player.hp_and_stuff.damaged_timer <= 0 and enemy.was_hit < 0.1:#and (enemy.sprite.position -enemy. player.position).length() < 400:
				enemy.player.hp_and_stuff.take_damage(damage,1)
				
				enemy.player.velocity += enemy.velocity
				#print("asas")
				#print((enemy.player.global_position-enemy.global_position).length())
			
		if enemy.chase_stamina > 0:
			enemy.chase_stamina -= _delta
	#	attack_time -= _delta


		if enemy.is_on_floor() and attack_time > 1:
			enemy.summon_wave(enemy.get_floor_normal(),enemy.velocity.normalized()*400 ,enemy.position)
			Playsound.get_playsound("res://sfx/explosion.mp3",enemy.position,0.11,randf_range(0.5,2),0.5)
			return chase_enemy
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return on_wave_enemy
func Exit():
		enemy.hitting = false
		pass
