class_name falling_enemy extends enemy_state_class
var name = "fallingE"
func Enter():
		enemy.faling = true

		pass

func Process(_delta):
		if enemy.hp_and_stuff.hp <= 0:
			return dead_enemy
		#if !guy1.is_on_floor():
			#guy1.saved_velocity = guy1.velocity/3
		enemy.velocity += enemy.get_gravity().length() * _delta * enemy.grav_dir
		enemy.move(enemy.direction,1)

		if enemy.is_on_floor():
			if state_machine.old_state is jumpin_enemy and randi_range(0,100)>50:
				enemy.summon_wave(enemy.get_floor_normal(),enemy.velocity/2 ,enemy.position)
			if enemy.player != null and !enemy.recharge_stamina:
				return chase_enemy

			return moving_enemy
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return on_wave_enemy
func Exit():
		enemy.faling = false
