class_name style extends jumpin
static var style_duration : float
func get_GuynStatemachine(guy,statemachine):
	
	name = "style"
	#print('smth_smth')
	guy1 = guy
	state_machine = statemachine

func Enter():
		guy1.find_anim(self)
		style_duration = 1
		guy1.on_air_time = 0.1
		#guy1.velocity *= abs(Vector2(guy1.grav_dir.y,guy1.grav_dir.x))
		guy1.velocity += guy1.JUMP_VELOCITY* 1.5 * (-guy1.grav_dir)


func Process(_delta):
		if guy1.on_wave != null and  style_duration < 0.75 and style_duration > 0.1:
			return ride_wave
		style_duration -= _delta
		guy1.velocity += guy1.get_gravity().length() * _delta * guy1.grav_dir
		#guy1.move(guy1.direction,1)
		if  (guy1.run and !guy1.finish_run) || (guy1.jumping and style_duration < 0.75):
			print("LLLLLLLLLLLLLLl")
			print(style_duration)
			guy1.run = false
			guy1.finish_run = true
			return moving
		elif style_duration < 0.05:
			return falling
	#	if guy1.is_on_floor() :

			#return moving
		if guy1.hitting and guy1.hit_timer <=0.01 and guy1.on_wave == null:
			return hit

func Exit():
		if style_duration < 0.05:
			print("yo thats fire")
			guy1.hp_and_stuff.fishes += 3

		guy1.styling = false
		guy1.faling = false
