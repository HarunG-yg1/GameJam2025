class_name harpooning extends state_class
var name = "harpooning"
#var falling : RefCounted = load("res://player/states/falling.gd")
static var harpoon_time : float = 0.6
static var swing_speed : Vector2
func get_GuynStatemachine(guy,statemachine):
	
#	print('smth_smth')
	guy1 = guy
	state_machine = statemachine
func Enter():
		guy1.find_anim(self)
		harpoon_time = 0.6
	#	guy1.hit_at_target()
		guy1.velocity = guy1.aim.aim_to_cursor * 2000
		swing_speed = guy1.aim.aim_to_cursor * 2000
func Process(_delta):
	
		if guy1.velocity.length() > swing_speed.length()/10:
			guy1.velocity -= swing_speed/1.5* _delta
			#aprint(guy1.velocity)
		
		harpoon_time -= _delta
		if harpoon_time < 0:
			return falling
func Exit():
		#guy1.hit_at_target()
	#	guy1.hit_targets.clear()

		pass
