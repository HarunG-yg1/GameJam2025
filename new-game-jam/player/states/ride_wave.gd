class_name ride_wave extends state_class
var name = "ride_wave"
static var timer : float = 0.12
static var old_rotation : float
static var dir_multiplier : Vector2 = Vector2(1,1)
func get_GuynStatemachine(guy,statemachine):
#	print('smth_smth')
	guy1 = guy
	state_machine = statemachine
func Enter():
		timer = 0.12
		dir_multiplier = Vector2(1,1)
		old_rotation = guy1.rotation

		pass
func Process(_delta):
		guy1.rotation = guy1.on_wave_dir.angle()
		if guy1.on_wave_dir.length() > 0 and guy1.on_wave != null:
			timer = 0.12
			guy1.velocity = ((guy1.on_wave_dir*guy1.on_wave.size*2+ guy1.velocity)* dir_multiplier).normalized() * (guy1.velocity.length()+.5) 
			#print(guy1.velocity)
	#	elif guy1.on_wave_dir.length() <= 0 and guy1.on_wave != null:
	#		guy1.velocity -= guy1.on_wave.lin_veloc*_delta
		if guy1.on_wave == null:
			timer -= _delta
		if timer <=0:
		#	print(guy1.velocity.length())
			return falling
		if guy1.aim.harpoon:
			return harpooning
		
func Exit():
		guy1.rotation = old_rotation 
		guy1.velocity = guy1.velocity.normalized() * guy1.JUMP_VELOCITY
