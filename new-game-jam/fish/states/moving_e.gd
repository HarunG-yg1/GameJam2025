class_name moving_enemy extends enemy_state_class
var name = "moving"
static var change_dir : bool
static var move_timer : float


func Enter():
		#change_dir = false
		move_timer = [3.5,2.0,4.0][randi_range(0,2)]
		

func Process(_delta):

	#	print(move_timer)
		move_timer -= _delta

		enemy.move(enemy.direction,1)
		if move_timer < 0 ||(enemy.get_last_slide_collision() != null and enemy.get_last_slide_collision().get_normal() != enemy.get_floor_normal() and (enemy.get_last_slide_collision().get_normal() + enemy.velocity.normalized()).length() < 1):
		#	print(enemy.is_on_floor())
			if enemy.on_air_time <0.2:
				
				return jumpin_enemy
			elif !change_dir:
				#change_dir = true
				enemy.dir_int *= -1
				return idle_enemy
			#	curent_time = move_timer
				
		if  (enemy.on_air_time >0.2):
			return falling_enemy
		if enemy.player != null and !enemy.recharge_stamina:
			return chase_enemy
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return on_wave_enemy
		#pass
func Exit():
		pass
