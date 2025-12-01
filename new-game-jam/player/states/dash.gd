class_name dash extends state_class
var name = "dash"
static var dash_window : float
static var boost : float
func get_GuynStatemachine(guy,statemachine):
	#print('smth_smth')
	guy1 = guy
	state_machine = statemachine
func Enter():
		guy1.hp_and_stuff.play_state_and_hurt_sound("res://sfx/Sound Effect Whoosh Sound (No Copyright).mp3",1.12,randf_range(0.5,2),0.2)
		guy1.find_anim(self)
		dash_window = 0.25
		boost = 5
		pass
func Process(delta):

		if dash_window > 0:
			guy1.move( (guy1.direction),boost)
			
			boost -= delta * 6
			dash_window -= delta
		else:
			guy1.jumping = false
			guy1.finish_run = true

			return moving
		if guy1.hitting and guy1.hit_timer <=0.01 and guy1.on_wave == null:
		#	guy1.finish_run = true
			guy1.finish_run = true
			
			return hit
		if guy1.on_wave!= null:
			return ride_wave
func Exit():
		pass
