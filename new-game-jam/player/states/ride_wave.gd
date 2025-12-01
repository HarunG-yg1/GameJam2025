class_name ride_wave extends state_class
var name = "ride_wave"
static var timer : float = 0.12
static var old_rotation : float
static var dir_multiplier : Vector2 = Vector2(1,1)
func get_GuynStatemachine(guy,statemachine):
	
	guy1 = guy
	state_machine = statemachine
func Enter():
		guy1.hp_and_stuff.play_state_and_hurt_sound("res://sfx/Minecraft Water Splash Sound Effect   SD 480p.mp3",0.4,1,0.2)
		guy1.find_anim(self)
		timer = 0.12
		dir_multiplier = Vector2(1,1)
	#	old_rotation = guy1.rotation
	#	if abs(guy1.on_wave.lin_veloc.x) > abs(guy1.on_wave.lin_veloc.y):
	#		dir_multiplier.y = guy1.on_wave.size/(( guy1.on_wave.lin_veloc *  guy1.on_wave.speed_modifier).length()/4) 
	#	elif abs(guy1.on_wave.lin_veloc.y) > abs(guy1.on_wave.lin_veloc.x):
	#		dir_multiplier.x = guy1.on_wave.size/(( guy1.on_wave.lin_veloc *  guy1.on_wave.speed_modifier).length()/4 )
		pass
func Process(_delta):
	
		if guy1.hp_and_stuff.hp <= 0:
			return dead
		#guy1.rotation = 
		if guy1.on_wave_dir.length() > 0 and guy1.on_wave != null:
			timer = 0.12
			
			if guy1.velocity.length() < (guy1.on_wave.linear_velocity).length() || (guy1.velocity.normalized() - guy1.on_wave_dir.normalized()).length() >1.414:
				guy1.velocity += (guy1.on_wave.lin_veloc.normalized()/6 + guy1.on_wave_dir).normalized() *  (guy1.on_wave.linear_velocity).length()/8
			#	print("guy1")
			
			else:
				guy1.velocity = (guy1.on_wave.linear_velocity)  + guy1.on_wave_dir * (guy1.on_wave.linear_velocity).length()/4
			#	print(str(guy1.velocity)+"guy1")
			#	print(guy1.on_wave.lin_veloc*guy1.on_wave.speed_modifier)
		elif guy1.on_wave_dir.length() <= 0 and guy1.on_wave != null:
			guy1.velocity -= guy1.on_wave.lin_veloc*_delta
		if guy1.on_wave == null:
			timer -= _delta
		if timer <=0:
		#	print(guy1.velocity.length())
			return falling
		if guy1.aim.harpoon:
			return harpooning
		if guy1.styling:
			#guy1.velocity +=  guy1.JUMP_VELOCITY * (-guy1.grav_dir)
			return style
		
func Exit():
	
		guy1.sprite.rotation = 0 
		if !guy1.styling:
			guy1.velocity = guy1.velocity.normalized() * guy1.JUMP_VELOCITY
			
