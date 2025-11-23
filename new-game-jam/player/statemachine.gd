class_name PlayerStateMachine
extends Node
var state_action
var states : Array[String] = ["moving","idle","dash","jumpin","falling","hit","ride_wave"]
var state : String = "idle"
var old_state : String 

var player 
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.

func init() -> void:
	self.process_mode = Node.PROCESS_MODE_INHERIT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"../Label".text = state
	state_enterer(state)
	if state_action != null:
		change_state(state_action.Process(delta))
	pass

func state_enterer(state_here:String):
	
	state_action = get(state_here).new()
	state_action.guy1 = self.player
	state_action.state_machine = self

func change_state(new_state):
	
	if new_state == null || new_state == state:
		return
	old_state = state
	state_action.Exit()
	state = new_state
	state_enterer(new_state)
	state_action.Enter()

class state_class:
	static var guy1 
	static var state_machine
	func Enter():
		pass
	func Process(_delta):
		pass
	func Exit():
		pass

class idle extends state_class:

	func Enter():

		pass
	func Process(_delta):


		if (guy1.velocity.length()) > 1 and !guy1.jumping:
			if guy1.on_wave == null:
				guy1.velocity.x -= guy1.velocity.x/15  
			else:
				guy1.velocity.x -= guy1.velocity.x/75
			if abs(guy1.velocity.x) < 1:
				guy1.velocity.x = 0
		if guy1.direction.length() > 0.0:
			
			return "moving"
		if( (guy1.velocity.normalized() - guy1.grav_dir).length() < 1 and guy1.velocity.length() > 0)|| (!guy1.is_on_floor() and !guy1.jumping):
			return "falling"
		if guy1.jumping and guy1.is_on_floor():
			return "jumpin"
		if guy1.hitting and guy1.hit_timer <=0.01 and guy1.on_wave == null:
			return "hit"
		if guy1.on_wave!= null:
			return "ride_wave"
	func Exit():
		pass


class moving extends state_class:
	static var air_time : float
	func Enter():
		pass
	func Process(_delta):
		if !guy1.is_on_floor():
			air_time += _delta
		else:
			air_time = 0
		guy1.move(guy1.direction,1)
		if guy1.direction.length() == 0.0:
			return "idle"
		elif guy1.run and !guy1.finish_run:
			return "dash"
		if guy1.jumping and guy1.is_on_floor():
			return "jumpin"
		if (air_time > 0.05 and (guy1.velocity.normalized() - guy1.grav_dir).length() < 1 and guy1.velocity.length() > 0) || (air_time > 0.05 and !guy1.jumping):
			return "falling"
		if guy1.hitting and guy1.hit_timer <=0.01 and guy1.on_wave == null:
			return "hit"
		if guy1.on_wave!= null:
			return "ride_wave"
	func Exit():
		pass

class dash extends state_class:
	static var dash_window : float
	static var boost : float
	func Enter():
		dash_window = 0.25
		boost = 3
		pass
	func Process(delta):

		if dash_window > 0:
			guy1.move( (guy1.direction),boost)
			
			boost -= delta * 8
			dash_window -= delta
		else:
			guy1.jumping = false
			guy1.finish_run = true

			return "moving"
		if guy1.hitting and guy1.hit_timer <=0.01 and guy1.on_wave == null:
		#	guy1.finish_run = true
			guy1.finish_run = true
			
			return "hit"
		if guy1.on_wave!= null:
			return "ride_wave"
	func Exit():
		pass

class jumpin extends state_class:
	static var on_air : float
	func Enter():
		on_air = 0.05
		guy1.velocity *= abs(Vector2(guy1.grav_dir.y,guy1.grav_dir.x))
		guy1.velocity += guy1.JUMP_VELOCITY * (-guy1.grav_dir)
		
		pass
	func Process(_delta):
		on_air -= _delta
		if !guy1.is_on_floor() and on_air < 0:
			guy1.velocity += guy1.get_gravity()* _delta
			
		guy1.move(guy1.direction ,1)
		if ((guy1.velocity.normalized() - guy1.grav_dir).length() < 1 and guy1.velocity.length() > 0 )|| (guy1.is_on_floor() and on_air < 0):
			guy1.jumping =  false
			return "falling"
		elif guy1.run and !guy1.finish_run:
			return "dash"
		if guy1.hitting and guy1.hit_timer <=0.01 and guy1.on_wave == null:
			return "hit"
		if guy1.on_wave!= null:
			guy1.jumping =  false
			return "ride_wave"
	func Exit():
		
		pass
	
class falling extends state_class:
	
	func Enter():
		guy1.falling = true


	func Process(_delta):
		#if !guy1.is_on_floor():
			#guy1.saved_velocity = guy1.velocity/3
		guy1.velocity += guy1.get_gravity() * _delta
		guy1.move(guy1.direction,1)
		if guy1.run and !guy1.finish_run:
			return "dash"
		if guy1.is_on_floor():
			
			return "moving"
		if guy1.hitting and guy1.hit_timer <= 0.01 and guy1.on_wave == null:
			return "hit"
		if guy1.on_wave!= null:
			return "ride_wave"

	func Exit():
		guy1.falling = false


class hit extends state_class:
	static var recorded_velocity : Vector2
	static var normal : Vector2
	static var player_last_position : Vector2
	static var deflect_distance : float
	
	static var hitted : bool = false
	func Enter():
		deflect_distance = 250
		if (recorded_velocity).length() > deflect_distance and (recorded_velocity).length() < 600:
			deflect_distance = (recorded_velocity).length()
		elif (recorded_velocity).length() > 600:
			deflect_distance = 600
		hitted = false
		recorded_velocity = guy1.velocity
		#print(recorded_velocity)

		if guy1.get_last_slide_collision() != null and !hitted:
			player_last_position  = guy1.position
			hitted = true
			normal = guy1.get_last_slide_collision().get_normal()
			if (state_machine.old_state != "falling" and state_machine.old_state != "dash")|| (state_machine.old_state == "dash" and ((guy1.velocity.normalized() + normal).length() > 0.75)):
				#print((guy1.velocity.normalized() + guy1.get_last_slide_collision().get_normal()).length())
				guy1.velocity = (normal/2 - guy1.grav_dir ).normalized() * (deflect_distance)
			else:
				
				guy1.velocity = (normal + guy1.velocity.normalized()/1.2 - guy1.grav_dir).normalized() *  (deflect_distance)
			#print(guy1.velocity)
			guy1.summon_wave(normal,recorded_velocity,player_last_position)

	func Process(_delta):
		if !guy1.is_on_floor():
				guy1.velocity += guy1.get_gravity()*1.2 * _delta
			
		if guy1.hit_timer >= 0.25:
			
			if state_machine.old_state != "jumpin" and state_machine.old_state != "dash":
				
				return state_machine.old_state
			else:
				guy1.jumping = false
				return "falling"
			#else:d
		if guy1.get_last_slide_collision() != null and !hitted:
			hitted = true
			player_last_position  = guy1.position
			normal = guy1.get_last_slide_collision().get_normal()

			if (state_machine.old_state != "falling" and state_machine.old_state != "dash")|| (state_machine.old_state == "dash" and ((guy1.velocity.normalized() + guy1.get_last_slide_collision().get_normal()).length() > 0.75)):
				#print("yo")
				guy1.velocity = (normal/2  - guy1.grav_dir).normalized() *  (deflect_distance)
			else:
				
				guy1.velocity = (normal + recorded_velocity.normalized()/1.2 - guy1.grav_dir).normalized() * (deflect_distance)
			guy1.summon_wave(normal,recorded_velocity,player_last_position)
			#print(guy1.velocity)

	func Exit():
		
		guy1.hit_timer = 0.25
		guy1.hitting = false


class ride_wave extends state_class:
	static var timer : float = 0.12
	static var old_rotation : float
	static var dir_multiplier : Vector2 = Vector2(1,1)
	func Enter():
		timer = 0.12
		dir_multiplier = Vector2(1,1)
		old_rotation = guy1.rotation
	#	if abs(sin(guy1.on_wave.rotation+deg_to_rad(90)))**2 < 0.5:
	#		dir_multiplier.x = 0.7
	#	if abs(cos(guy1.on_wave.rotation+deg_to_rad(90)))**2 < 0.5:
	#		dir_multiplier.y = 0.7
	#	print(dir_multiplier)
		#Vector2(sin(guy1.on_wave.rotation+deg_to_rad(90)),cos(guy1.on_wave.rotation+deg_to_rad(90)))

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
			print(guy1.velocity.length())
			return "falling"
		pass
	func Exit():
		guy1.rotation = old_rotation 
		#wguy1.velocity *= 1.2
		pass
