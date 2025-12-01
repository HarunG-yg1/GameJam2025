class_name attack_enemy extends enemy_state_class
var name = "attack"
static var damage : int = 2
static var attack_time:float
static var change_attack_chance: float = 0
func Enter():
		enemy.hp_and_stuff.play_state_and_hurt_sound("res://sfx/Sound Effect Whoosh Sound (No Copyright).mp3",1.12,enemy.fish_settings.pitch,0.6)
		enemy.hitting = true
		attack_time = 0.5
		enemy.velocity = (enemy.player.global_position-enemy.sprite.global_position).normalized()*enemy.JUMP_VELOCITY
		if enemy.fish_type == "sword_fish" || enemy.fish_type == "whale":
			change_attack_chance = randi_range(0,100)
		pass
func Process(_delta):
		if enemy.hp_and_stuff.hp <= 0:
			return dead_enemy
		if  (enemy.player.global_position-enemy.sprite.global_position).length() < 8 * enemy.scale.length():
			if enemy.hitting and enemy.player.finish_run and enemy.player.hp_and_stuff.damaged_timer <= 0 and enemy.was_hit < 0.1:#and (enemy.sprite.position -enemy. player.position).length() < 400:
				enemy.player.hp_and_stuff.take_damage(damage,1)
				enemy.player.velocity += enemy.velocity
				print("bruv")
		if change_attack_chance > 40:
			if enemy.fish_type == "sword_fish":
				
				return attack_enemy2
			elif enemy.fish_type == "whale":
				return attack_enemy3
		enemy.chase_stamina -= _delta
		attack_time -= _delta 

		if !enemy.is_on_floor() and enemy.on_air_time > 0.2:
			enemy.velocity += enemy.get_gravity().length() * _delta * enemy.grav_dir
		if enemy.get_last_slide_collision() != null and enemy.get_last_slide_collision().get_normal() != enemy.get_floor_normal() and (enemy.get_last_slide_collision().get_normal() + enemy.velocity.normalized()).length() < 1:
			enemy.dir_int *= -1
		if attack_time <=0:
			return chase_enemy
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return on_wave_enemy
func Exit():
		enemy.hitting = false
		pass
