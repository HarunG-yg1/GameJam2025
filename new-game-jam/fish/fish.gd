class_name fish
extends CharacterBody2D

var direction : Vector2

var original_wave = preload("res://wave/wave.tscn")
var faling := false
var jumping : bool = false

var finish_run = true
var grav_dir := Vector2(0,1)
var recharge_stamina : bool = false
var was_hit : float 
var on_air_time : float
var on_wave : Wave
var hitting := false
var run = false
const INITIAL_SPEED = 55.0
var player = null

var wave = null
var classname : String = "fish"
var wave_invulnerability_time : float = 0

@export var fish_settings : Fish_settings
var fish_type : String 
var states : Array 
var MAX_SPEED : float
var JUMP_VELOCITY : float 
var max_wave_invulnerability_time : float

var dir_int : int 
var chase_stamina : float
var weight_priority : int 
var sprite2 : Texture2D
@onready var sprite = $Sprite2D
@onready var detect_area =$Area2D
@onready var statemachine = $statemachine

func _ready() -> void:
	fish_settings.mass_export(self)
	statemachine.enemy = self
	statemachine.init(states)

func _process(delta: float) -> void:
	
		#print("yoyyy")
		#print((global_position - player.global_position).length() )
		
	if was_hit > 0:
		was_hit -= delta
	
	if wave_invulnerability_time > 0:
		wave_invulnerability_time -= delta
	if recharge_stamina and chase_stamina < 4:
		$Label2.text = "tired"
		chase_stamina += delta
	else:
		$Label2.text = ""
		recharge_stamina = false
	if chase_stamina <= 0 and !recharge_stamina:
		recharge_stamina = true
	detect_area.rotation = velocity.angle()
	if is_on_floor():
		on_air_time = 0
	else:
		on_air_time += delta
	
	if on_air_time < 0.2 and is_on_floor():
		
		direction =( (Vector2(cos(get_floor_normal().angle() + deg_to_rad(90)),sin(get_floor_normal().angle() + deg_to_rad(90))) )* dir_int).normalized() 
	#	print(direction)
	elif on_air_time >= 0.2 and !is_on_floor():
		
		direction =  abs(Vector2(grav_dir.y,grav_dir.x)) * dir_int 

	#	print(on_wave_dir)
func _physics_process(delta: float) -> void:
	move_and_slide()

func move(direct,modifier):
		if (direct.length()) > 0.0:
			if (((velocity-(grav_dir*velocity.length())).length()) <  MAX_SPEED) and statemachine.state is falling_enemy || (velocity.length()) <  MAX_SPEED :

				velocity += ((direct) * INITIAL_SPEED) *modifier
			else:
				if abs(modifier) == 1 and (velocity.normalized() - direct.normalized()).length() >1:
					
					velocity += direct * INITIAL_SPEED *modifier
				elif statemachine.state is jumpin_enemy and  statemachine.state is not attack_enemy and statemachine.state is not falling_enemy :
	
					velocity = (direct * MAX_SPEED ) *modifier #+  Vector2(0,Input.get_action_strength("ui_down")) * MAX_SPEED
		else:
			if on_air_time > 0.2:
				velocity -= abs(Vector2(grav_dir.y,grav_dir.x))*  velocity /75
			else:
				velocity -=  velocity /75 +  Vector2(0,Input.get_action_strength("ui_down")) * MAX_SPEED #+  Vector2(0,Input.get_action_strength("ui_down")) * MAX_SPEED
func summon_wave(normal,recorded_velocity,player_last_position):
	
	#print((saved_velocity* normal))
	var additional_velocity : Vector2
	var new_wave = original_wave.instantiate().duplicate()
	new_wave.origin_summon = classname
#	print(new_wave.origin_summon)
	new_wave.global_position = player_last_position + normal* 2#=  no_contact_list[i].global_position - lin_veloc.normalized()*16 # - 2.5* Vector2(cos(gotofloor.rotation + deg_to_rad(90)),sin(gotofloor.rotation + deg_to_rad(90))) 
	new_wave.rotation = normal.angle() + deg_to_rad(90)#(-lin_veloc).angle()
	new_wave.size = 16 + weight_priority#+(recorded_velocity* normal).length() / 16
	if abs(normal.x) > abs(normal.y):
		additional_velocity = -(JUMP_VELOCITY/2.5) * -Vector2(normal.y,normal.x)

	new_wave.lin_veloc =  (recorded_velocity  * -Vector2(normal.y,normal.x)) + additional_velocity #d+ Vector2(0,Input.get_action_strength("ui_down")) * MAX_SPEED/2
	get_parent().add_child(new_wave)



func _on_area_2d_body_entered(body: PhysicsBody2D) -> void:
	if body is Player and !recharge_stamina:
		player = body



func _on_area_2d_body_exited(body: PhysicsBody2D) -> void:
	if body is Player:
		pass
	#	player = null

		
