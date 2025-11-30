class_name moving extends state_class
var name = "moving"
func get_GuynStatemachine(guy,statemachine):
	#print('smth_smth')
	guy1 = guy
	state_machine = statemachine
func Enter():
		guy1.find_anim(self)
		pass
func Process(_delta):

		if guy1.hp_and_stuff.hp <= 0:
			return dead
		guy1.move(guy1.direction,1)
		if guy1.direction.length() == 0.0:
			return idle
		elif guy1.run and !guy1.finish_run:
			return dash
		if guy1.jumping:
			return jumpin
		if  guy1.on_air_time >0.25:#  and (guy1.velocity.normalized() - guy1.grav_dir).length() < 0.1 ||  (guy1.velocity * abs(guy1.grav_dir)).length() <= 10:
			return falling
		if guy1.hitting and guy1.hit_timer <=0.01 and guy1.on_wave == null:
			return hit
		if guy1.on_wave!= null:
			return ride_wave
		if guy1.aim.harpoon:
			return harpooning
func Exit():
		pass
