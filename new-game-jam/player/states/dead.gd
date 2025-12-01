class_name dead extends idle

func get_GuynStatemachine(guy,statemachine):
	name = "dead"
	#print('smth_smth')
	guy1 = guy
	state_machine = statemachine
func Enter():
	guy1.hp_and_stuff.play_state_and_hurt_sound("res://sfx/some cruelty squad sfx.mp3",0.4,1,0.6)
	Playsound.get_playsound("res://sfx/explosion.mp3",guy1.position,0,1)
	guy1.find_anim(self)
	guy1.collision.disabled = true
	guy1.set_process(true)
	Finish.restart()
	pass
func Process(_delta):
		
		
		if (guy1.velocity.length()) > 1 and !guy1.jumping:
			if guy1.on_wave == null:
				guy1.velocity -= (guy1.velocity * abs(Vector2(guy1.grav_dir.y,guy1.grav_dir.x)))/15  
			else:
				guy1.velocity -= (guy1.velocity * abs(Vector2(guy1.grav_dir.y,guy1.grav_dir.x)))/75 
			if abs(guy1.velocity.x) < 1:
				guy1.velocity.x = 0
		#if guy1.direction.length() > 0.0:
			
	#		return moving
	#	if  guy1.on_air_time >0.1:  #and (guy1.velocity.normalized() - guy1.grav_dir).length() < 0.1 :#||  (guy1.velocity * abs(guy1.grav_dir)).length() <= 10:
	#		return falling
#		if guy1.jumping:
	#		return jumpin
	#	if guy1.hitting and guy1.hit_timer <=0.01 and guy1.on_wave == null:
#			return hit
#		if guy1.on_wave!= null:
#			return ride_wave
	#	if guy1.aim.harpoon:
		#	return harpooning
func Exit():
		pass
