class_name style extends falling
static var style_duration : float
func get_GuynStatemachine(guy,statemachine):

	#print('smth_smth')
	guy1 = guy
	state_machine = statemachine
func Enter():
		style_duration = 0.5
		name = "falling"
		guy1.faling = true


func Process(_delta):
		style_duration -= _delta
		guy1.velocity += guy1.get_gravity() * _delta
		#guy1.move(guy1.direction,1)
		if style_duration < 0 :
			return falling
		if guy1.is_on_floor():
			
			return moving

		if guy1.on_wave!= null:
			return ride_wave

func Exit():
		if guy1.hp_and_stuff.hp + 3 < guy1.hp_and_stuff.MAX_HP:
			guy1.hp_and_stuff.hp += 3
		else:
			guy1.hp_and_stuff.hp = guy1.hp_and_stuff.MAX_HP
		guy1.styling = false
		guy1.faling = false
