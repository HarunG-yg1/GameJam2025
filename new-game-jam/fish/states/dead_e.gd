class_name dead_enemy extends idle_enemy

func Enter():
	enemy.die()
	enemy.hp_and_stuff.play_state_and_hurt_sound("res://sfx/some cruelty squad sfx.mp3",0.4,enemy.fish_settings.pitch,0.6)
	Playsound.get_playsound("res://sfx/explosion.mp3",enemy.position,0,enemy.fish_settings.pitch*2)
	enemy.collision.disabled = true
	enemy.sprite.visible = false
	enemy.animated_sprite.visible = true
	enemy.animated_sprite.play("dead")
	enemy.set_process(false)
	enemy.velocity *= 0
	enemy.statemachine.set_process(false)
	
	name = "dead"
	pass

func Exit():
		pass
