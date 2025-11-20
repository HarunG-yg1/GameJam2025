class_name PlayerStateMachine
extends Node
var state_action
var states : Array[String] = ["moving","idle","dash","jumpin","falling","hit"]#,"smashing","ability"]
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
		if (guy1.velocity.normalized() - guy1.grav_dir).length() < 1 and guy1.velocity.length() > 0:
			return "falling"
		if guy1.jumping:
			return "jumpin"
		if guy1.hitting and guy1.hit_timer <=0.01:
			return "hit"
	func Exit():
		pass


class moving extends state_class:

	func Enter():
		pass
	func Process(_delta):

		guy1.move(guy1.direction,1)
		if guy1.direction.length() == 0.0:
			return "idle"
		elif guy1.run and !guy1.finish_run:
			return "dash"
		if guy1.jumping:
			return "jumpin"
		if (guy1.velocity.normalized() - guy1.grav_dir).length() < 1 and guy1.velocity.length() > 0:
			return "falling"
		if guy1.hitting and guy1.hit_timer <=0.01:
			return "hit"
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
		if guy1.hitting and guy1.hit_timer <=0.01:
			guy1.finish_run = true
			return "hit"
	func Exit():
		pass

class jumpin extends state_class:
	static var on_air : bool
	func Enter():
		on_air = false
		guy1.velocity += guy1.JUMP_VELOCITY * (-guy1.grav_dir)
		
		pass
	func Process(_delta):
		
		if !guy1.is_on_floor():
			on_air = true
		guy1.move(guy1.direction ,1)
		if ((guy1.velocity.normalized() - guy1.grav_dir).length() < 1 and guy1.velocity.length() > 0 )|| (guy1.is_on_floor() and on_air):
			guy1.jumping =  false
			return "falling"
		elif guy1.run and !guy1.finish_run:
			return "dash"
		if guy1.hitting and guy1.hit_timer <=0.01:
			return "hit"

	func Exit():
		pass
	
class falling extends state_class:
	
	func Enter():
		guy1.falling = true
		print("nih")
		pass
	func Process(delta):
		#if !guy1.is_on_floor():
			#guy1.saved_velocity = guy1.velocity/3
		
		guy1.move(guy1.direction,1)
		if guy1.run and !guy1.finish_run:
			return "dash"
		if guy1.is_on_floor():
			
			return "moving"
		if guy1.hitting and guy1.hit_timer <= 0.01:
			return "hit"
		pass

	func Exit():
		guy1.falling = false
		pass

class hit extends state_class:
	static var recorded_velocity : Vector2
	static var normal : Vector2
	static var player_last_position : Vector2
	
	var deflect_distance = 450.0
	static var hitted : bool = false
	func Enter():
		
		hitted = false
		recorded_velocity = guy1.velocity
		if guy1.get_last_slide_collision() != null and !hitted:
			player_last_position  = guy1.position
			hitted = true
			normal = guy1.get_last_slide_collision().get_normal()
			

			
			if (state_machine.old_state != "falling" and state_machine.old_state != "dash")|| (state_machine.old_state == "dash" and ((guy1.velocity.normalized() + normal).length() > 0.75)):
				#print((guy1.velocity.normalized() + guy1.get_last_slide_collision().get_normal()).length())
				guy1.velocity = (normal  + guy1.velocity.normalized()/2 - guy1.grav_dir).normalized()  *deflect_distance
			else:
				
				guy1.velocity = (normal- guy1.velocity.normalized()/2 - guy1.grav_dir).normalized() * deflect_distance
			guy1.summon_wave(normal,recorded_velocity,player_last_position)
		pass
	func Process(delta):
		
			
		if guy1.hit_timer >= 0.2:
			#guy1.velocity *= 0.05
			#if guy1.is_on_floor():
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
				print((guy1.velocity.normalized() +normal).length())
				guy1.velocity = (normal  + guy1.velocity.normalized() - guy1.grav_dir/2).normalized()  *deflect_distance
			else:
				
				guy1.velocity = (normal - guy1.velocity.normalized() - guy1.grav_dir/2).normalized() * deflect_distance
			guy1.summon_wave(normal,recorded_velocity,player_last_position)
		pass

	func Exit():

		guy1.hit_timer = 0.25
		guy1.hitting = false

		pass
