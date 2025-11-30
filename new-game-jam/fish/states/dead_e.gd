class_name dead_enemy extends idle_enemy


func Enter():
	enemy.die()
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
