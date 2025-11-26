class_name  idle_enemy extends enemy_state_class
var name = "idle"
static var idle_timer : float = 1
func Enter():
		idle_timer = [1.5,2,0.5][randi_range(0,2)]
		pass
func Process(_delta):
		idle_timer -= _delta
		if (enemy.velocity.length()) > 1:
			enemy.velocity.x -= enemy.velocity.x/15  

			if abs(enemy.velocity.x) < 1:
				enemy.velocity.x = 0
		if idle_timer < 0:
			if enemy.on_air_time == 0 and enemy.is_on_floor():
				return [jumpin_enemy,moving_enemy][randi_range(0,1)]
		if  (enemy.on_air_time >0.2):
			return falling_enemy

		if enemy.player != null:
			return chase_enemy
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return on_wave_enemy
func Exit():
		pass
