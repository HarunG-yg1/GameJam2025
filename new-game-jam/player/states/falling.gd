class_name falling extends state_class
var name = "falling"
static var time_spent_inState :  float
func get_GuynStatemachine(guy,statemachine):
	#print('smth_smth')
	guy1 = guy
	state_machine = statemachine
func Enter():
		guy1.find_anim(self)
		
		time_spent_inState = 0
		guy1.faling = true
		guy1.jumping = false


func Process(_delta):
		if guy1.hp_and_stuff.hp <= 0:
			return dead
		time_spent_inState += _delta
		#if !guy1.is_on_floor():
			#guy1.saved_velocity = guy1.velocity/3
		guy1.velocity += guy1.get_gravity().length() * _delta * guy1.grav_dir
		guy1.move(guy1.direction,1)
		if guy1.run and !guy1.finish_run:
			return dash
		if guy1.is_on_floor():
			guy1.hp_and_stuff.play_state_and_hurt_sound("res://sfx/Lancer Splat Sound Effect (Deltarune).mp3",0.45,1,0.2)
			return moving
		if guy1.hitting and guy1.hit_timer <= 0.01 and guy1.on_wave == null:
			return hit
		if guy1.on_wave!= null:
			if state_machine.old_state is style:
				guy1.hp_and_stuff.multiplier +=1
			#	guy1.hp_and_stuff.multiplier_bar.value = 100.0
			#	print("YOOOOOOOOOOOO HOLY SHIT")
				
			return ride_wave
		if guy1.aim.harpoon:
			return harpooning
		if guy1.styling and (state_machine.old_state is ride_wave || state_machine.old_state is style ) and time_spent_inState < 1.5:
			
			#guy1.velocity +=  guy1.JUMP_VELOCITY * (-guy1.grav_dir)
			return style

func Exit():
		guy1.faling = false
