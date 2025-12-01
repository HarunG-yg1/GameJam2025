class_name jumpin extends state_class
var name = "jumpin"
func get_GuynStatemachine(guy,statemachine):
	#print('smth_smth')
	guy1 = guy
	state_machine = statemachine
func Enter():
		guy1.hp_and_stuff.play_state_and_hurt_sound("res://sfx/Old ROBLOX Splat⧸Tripping Sound.mp3",0.4)
		guy1.find_anim(self)
		guy1.on_air_time = 0.1
		#guy1.velocity *= abs(Vector2(guy1.grav_dir.y,guy1.grav_dir.x))
		guy1.velocity += guy1.JUMP_VELOCITY * (-guy1.grav_dir)
		
		pass
func Process(_delta):
	
		if !guy1.is_on_floor() and guy1.on_air_time >0.2:
			guy1.velocity += guy1.get_gravity().length() * _delta * guy1.grav_dir
		elif guy1.is_on_floor() and state_machine.inState_time > 0.2:
			
			return moving
			
		guy1.move(guy1.direction ,1)
		if  guy1.on_air_time >0.2  and   (guy1.velocity * abs(guy1.grav_dir)).length() <= 5:
			
			
			return falling
		
		elif guy1.run and !guy1.finish_run:
			return dash
		if guy1.hitting and guy1.hit_timer <=0.01 and guy1.on_wave == null:
			return hit
		if guy1.on_wave!= null:
			
			return ride_wave
		if guy1.aim.harpoon:
			return harpooning

func Exit():
		guy1.jumping =  false
		pass
	
