class_name falling extends state_class
var name = "falling"
func get_GuynStatemachine(guy,statemachine):
	#print('smth_smth')
	guy1 = guy
	state_machine = statemachine
func Enter():
		guy1.faling = true


func Process(_delta):
		#if !guy1.is_on_floor():
			#guy1.saved_velocity = guy1.velocity/3
		guy1.velocity += guy1.get_gravity() * _delta
		guy1.move(guy1.direction,1)
		if guy1.run and !guy1.finish_run:
			return dash
		if guy1.is_on_floor():
			
			return moving
		if guy1.hitting and guy1.hit_timer <= 0.01 and guy1.on_wave == null:
			return hit
		if guy1.on_wave!= null:
			return ride_wave
		if guy1.aim.harpoon:
			return harpooning
		if guy1.styling:
			return style
func Exit():
		guy1.faling = false
