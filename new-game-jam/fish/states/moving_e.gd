class_name moving_enemy extends enemy_state_class
var name = "moving"

static var move_timer : float


func Enter():
		enemy.dir_int = [-1,1][randi_range(0,1)]
		move_timer = [3.5,2.0,4.0][randi_range(0,2)]
		

func Process(_delta):
		if enemy.hp_and_stuff.hp <= 0:
			return dead_enemy
	#	print(move_timer)
		move_timer -= _delta
		if  enemy.get_last_slide_collision() != null and (enemy.get_last_slide_collision().get_normal() - enemy.velocity.normalized()).length() > 1.5:
				enemy.dir_int *= -1
				enemy.velocity += -1 *abs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x)) * enemy.velocity
				return [moving_enemy,jumpin_enemy][randi_range(0,1)]
		enemy.move(enemy.direction,1)
		if move_timer < 0:
			enemy.hp_and_stuff.play_state_and_hurt_sound("res://sfx/Wii Sports - Groan Sound Effect.mp3",0,4*enemy.fish_settings.pitch,0.7)
		#	print(enemy.is_on_floor())
			if enemy.on_air_time <0.2:
				return [idle_enemy,jumpin_enemy][randi_range(0,1)]			#	curent_time = move_timer
				
		if  (enemy.on_air_time >0.2) and !enemy.is_on_floor():
			return falling_enemy
		if enemy.player != null and !enemy.recharge_stamina:
			return chase_enemy
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return on_wave_enemy
		#pass
func Exit():
		pass
