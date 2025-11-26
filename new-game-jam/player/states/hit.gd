class_name hit extends state_class
var name = "hit"
static var recorded_velocity : Vector2
static var normal : Vector2
static var player_last_position : Vector2
static var deflect_distance : float
	
static var hitted : bool = false
func get_GuynStatemachine(guy,statemachine):
	#print('smth_smth')
	guy1 = guy
	state_machine = statemachine
func Enter():
		guy1.hurtbox.monitoring = true
		deflect_distance = 400
		if (recorded_velocity).length() > deflect_distance and (recorded_velocity).length() < 600:
			deflect_distance = (recorded_velocity).length()
		elif (recorded_velocity).length() > 600:
			deflect_distance = 600
		hitted = false
		recorded_velocity = guy1.velocity
		#print(recorded_velocity)

		if guy1.get_last_slide_collision() != null and !hitted:
			#print(guy1.get_last_slide_collision())
			player_last_position  = guy1.position
			hitted = true
			normal = guy1.get_last_slide_collision().get_normal()
			if (state_machine.old_state is falling and state_machine.old_state is not dash)|| (state_machine.old_state is dash and ((guy1.velocity.normalized() + normal).length() > 0.75)):
				#print((guy1.velocity.normalized() + guy1.get_last_slide_collision().get_normal()).length())
				guy1.velocity = (normal/2 - guy1.grav_dir ).normalized() * (deflect_distance)
			else:
				
				guy1.velocity = (normal + guy1.velocity.normalized()/1.2 - guy1.grav_dir).normalized() *  (deflect_distance)
			if guy1.wave_charge > 0:
				guy1.summon_wave(normal,recorded_velocity,player_last_position)

func Process(_delta):
		if guy1.aim.harpoon:
			return harpooning
		if !guy1.is_on_floor():
				guy1.velocity += guy1.get_gravity()*1.2 * _delta
			
		if guy1.hit_timer >= 0.25:
			
			if state_machine.old_state is not jumpin and state_machine.old_state is not dash:
				#print(state_machine.old_state.name)
				return (state_machine.old_state)
			else:
				guy1.jumping = false
				return falling
			#else:d
		if guy1.get_last_slide_collision() != null and !hitted:
			hitted = true
			player_last_position  = guy1.position
			normal = guy1.get_last_slide_collision().get_normal()

			if (state_machine.old_state is not falling and state_machine.old_state is not dash)|| (state_machine.old_state is dash and ((guy1.velocity.normalized() + guy1.get_last_slide_collision().get_normal()).length() > 0.75)):
				#print("yo")
				guy1.velocity = (normal/2  - guy1.grav_dir).normalized() *  (deflect_distance)
			else:
				
				guy1.velocity = (normal + recorded_velocity.normalized()/1.2 - guy1.grav_dir).normalized() * (deflect_distance)
			if guy1.wave_charge > 0:
				guy1.summon_wave(normal,recorded_velocity,player_last_position)
			#print(guy1.velocity)

func Exit():
		guy1.hurtbox.monitoring = false
		guy1.hit_timer = 0.25
		guy1.hitting = false
