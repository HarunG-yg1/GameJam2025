class_name enemystatemachine
extends Node
var state_action
@export var states : Array[String] = ["moving","idle","jumpin","falling","chase","attack","on_wave"]
var state : String = "idle"
var old_state : String 

var enemy
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
	state_action.enemy = self.enemy
	state_action.state_machine = self

func change_state(new_state):
	
	if new_state == null || new_state == state || new_state not in states:
		return
	old_state = state
	state_action.Exit()
	state = new_state
	state_enterer(new_state)
	state_action.Enter()

class state_class:
	static var enemy
	static var state_machine
	func Enter():
		pass
	func Process(_delta):
		pass
	func Exit():
		pass
		
class idle extends state_class:
	static var idle_timer : float
	func Enter():
		idle_timer = [1.5,2,0.5][randi_range(0,2)]
		pass
	func Process(_delta):
		idle_timer -= _delta
		if (enemy.velocity.length()) > 1:
			enemy.velocity.x -= enemy.velocity.x/15  

			if abs(enemy.velocity.x) < 1:
				enemy.velocity.x = 0
		if idle_timer < 0:
			if enemy.on_air_time == 0:
				return ["jumpin","moving"][randi_range(0,1)]
			else:
				return "falling"

		if enemy.player != null:
			return "chase"
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return "on_wave"
	func Exit():
		pass

class moving extends state_class:
	#static var dir : int
	static var change_dir : bool
	static var move_timer : float


	func Enter():
		#change_dir = false
		move_timer = [3.5,2.0,4.0][randi_range(0,2)]
		
		pass
	func Process(_delta):

	#	print(move_timer)
		move_timer -= _delta

		enemy.move(enemy.direction,1)
		if move_timer < 0 ||(enemy.get_last_slide_collision() != null and enemy.get_last_slide_collision().get_normal() != enemy.get_floor_normal() and (enemy.get_last_slide_collision().get_normal() + enemy.velocity.normalized()).length() < 1):
		#	print(enemy.is_on_floor())
			if enemy.on_air_time <0.2:
				
				return "jumpin"
			elif !change_dir:
				#change_dir = true
				enemy.dir_int *= -1
				return "idle"
			#	curent_time = move_timer
				
		if  (enemy.on_air_time >0.2):
			return "falling"
		if enemy.player != null and !enemy.recharge_stamina:
			return "chase"
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return "on_wave"
		#pass
	func Exit():
		pass


class jumpin extends state_class:


	func Enter():
		enemy.jumping = true

		enemy.on_air_time = 0.1
		enemy.velocity *= abs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x))
		enemy.velocity += enemy.JUMP_VELOCITY * (-enemy.grav_dir)
		
		pass
	func Process(_delta):

		if !enemy.is_on_floor() and enemy.on_air_time > 0.2:
			enemy.velocity += enemy.get_gravity()* _delta
		elif enemy.is_on_floor():
			#enemy.dir_int *= -1
			return "moving"
		
		enemy.move(enemy.direction ,1)
		
		if  enemy.on_air_time >0.2  and (enemy.velocity.normalized() - enemy.grav_dir).length() < 1 ||  (enemy.velocity * abs(enemy.grav_dir)).length() <= 10:
			enemy.jumping =  false
			if  enemy.get_last_slide_collision() != null and enemy.get_last_slide_collision().get_normal() != enemy.get_floor_normal() and (enemy.get_last_slide_collision().get_normal() + enemy.velocity.normalized()).length() < 1:
				enemy.dir_int *= -1
			return "falling"
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return "on_wave"

	func Exit():
		
		pass
	
class falling extends state_class:
	
	func Enter():
		enemy.falling = true
		pass

	func Process(_delta):
		#if !guy1.is_on_floor():
			#guy1.saved_velocity = guy1.velocity/3
		enemy.velocity += enemy.get_gravity() * _delta
		enemy.move(enemy.direction,1)

		if enemy.is_on_floor():
			#if state_machine.old_state == "jumpin":
			#	enemy.summon_wave(enemy.get_floor_normal(),enemy.velocity ,enemy.position)
			if enemy.player != null and !enemy.recharge_stamina:
				return "chase"
			return "moving"
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return "on_wave"
	func Exit():
		enemy.falling = false

class chase extends state_class:
	
	func Enter():
		#if  ((enemy.position - enemy.player.position).normalized() * abs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x))).normalized().x > ((enemy.position - enemy.player.position).normalized() * abs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x))).normalized().y:
		if ((enemy.player.global_position-enemy.global_position).normalized() + enemy.direction).length() <1:
			enemy.dir_int *= -1
		#else:
		#	enemy.dir_int = ((enemy.position - enemy.player.position).normalized() * abs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x)).normalized().x) / abs((enemy.position - enemy.player.position).normalized() * abs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x)).normalized().y)
			
	func Process(_delta):
		enemy.chase_stamina -= _delta *2
		if  enemy.get_last_slide_collision() != null and enemy.get_last_slide_collision().get_normal() != enemy.get_floor_normal() and (enemy.get_last_slide_collision().get_normal() + enemy.velocity.normalized()).length() < 1 and enemy.on_air_time == 0:
			#change_dir = true
			return "jumpin"
		if enemy.player != null and ((enemy.player.global_position-enemy.global_position).normalized() + enemy.direction).length() <1 and (enemy.position - enemy.player.position).length() > 120:
			enemy.dir_int *= -1
		elif  enemy.player != null and (enemy.player.global_position-enemy.global_position).length() < 120 and enemy.is_on_floor():
			return "attack"
		enemy.move(enemy.direction,1)
		if  enemy.on_air_time >0.2  and (enemy.velocity.normalized() - enemy.grav_dir).length() < 1 ||  (enemy.velocity * abs(enemy.grav_dir)).length() <= 10:
			return "falling"
		if enemy.recharge_stamina:
			enemy.player = null
			return "moving"
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return "on_wave"
	func Exit():
		#enemy.dir_int *= -1
		pass

class attack extends state_class:
	static var attack_time:float
	func Enter():
		#if ((enemy.position - enemy.player.position).normalized() - enemy.direction).length() <1:
	#		enemy.dir_int *= -1
		attack_time = 0.5
		enemy.velocity = (enemy.player.global_position-enemy.grav_dir*64-enemy.global_position).normalized()*400 
		#print( enemy.player.global_position- enemy.global_position )
		#print(enemy.global_position)
		#print(enemy.player.global_position)
		pass
	func Process(_delta):
		enemy.chase_stamina -= _delta
		attack_time -= _delta *4
		#enemy.move(enemy.direction,2)
		if !enemy.is_on_floor() and enemy.on_air_time > 0.2:
			enemy.velocity += enemy.get_gravity()* _delta
		if enemy.get_last_slide_collision() != null and enemy.get_last_slide_collision().get_normal() != enemy.get_floor_normal() and (enemy.get_last_slide_collision().get_normal() + enemy.velocity.normalized()).length() < 1:
			enemy.dir_int *= -1
		if attack_time <=0:
			return "chase"
		if enemy.wave != null and enemy.wave_invulnerability_time <= 0:
			return "on_wave"
	func Exit():
		pass

class on_wave extends state_class:
	static var stun_time : float 
	static var jumping : Vector2
	func Enter():
		
		stun_time = 4
		enemy.on_air_time = 0.1
		enemy.velocity *= 0 #dabs(Vector2(enemy.grav_dir.y,enemy.grav_dir.x))
		jumping = enemy.wave.size * 10 * (-enemy.grav_dir)
		enemy.velocity += enemy.wave.size * 10 * (-enemy.grav_dir)
		
		pass
	func Process(_delta):
		stun_time -= _delta
		
		if stun_time < 0:
			return "falling"
		if !enemy.is_on_floor() and enemy.on_air_time > 0.2:
			enemy.velocity += enemy.get_gravity()* _delta
	#	else:
			#enemy.velocity = jumping /10

	func Exit():
		enemy.wave_invulnerability_time = 2
		
		
	
