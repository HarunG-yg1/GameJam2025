class_name Player
extends CharacterBody2D
var on_wave_dir : Vector2
var direction : Vector2

var original_wave = preload("res://wave/wave.tscn")

var on_wave : Wave
const INITIAL_SPEED = 55.0
const MAX_SPEED = 300.0

const JUMP_VELOCITY = 400

var wave_charge : float
var on_air_time : float
var faling := false
var jumping : bool = false
var styling : bool = false
var hit_timer := 0.25

var hitting := false
var run = false
var finish_run = true

var grav_dir := Vector2(0,1)
@onready var hp_and_stuff =$hp_and_stuff
@onready var aim = $aim
@onready var sprite = $Sprite2D
@onready var hurtbox = $Area2D
@onready var statemachine = $statemachine
func _ready() -> void:
	
	statemachine.player = self
	statemachine.init()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reload"):
		wave_charge = 3
	if wave_charge > 0:
		wave_charge -= delta
	if Input.is_action_just_pressed("dash") and finish_run and !run and velocity.length()>1:
		run = true
		finish_run = false
		await get_tree().create_timer(1).timeout
		run = false

	if not is_on_floor() and on_wave == null:
		velocity += (grav_dir) * Input.get_action_strength("ui_down") * MAX_SPEED/5

	if Input.is_action_just_pressed("ui_accept") and !faling and !jumping and on_air_time < 0.2:
		jumping = true

		
	if Input.is_action_just_pressed("hit") and hit_timer >= 0.25:
		hitting = true
		hit_timer = 0

	if hit_timer < 0.25 and hitting:
		hit_timer += delta
	elif hit_timer >= 0.25 and hitting:
		hitting = false
		
	if is_on_floor():
		on_air_time = 0
	else:
		on_air_time += delta
	
	if on_air_time < 0.2 and is_on_floor():
		
		direction =( Vector2(cos(get_floor_normal().angle() + deg_to_rad(90)),sin(get_floor_normal().angle() + deg_to_rad(90))) * Input.get_axis("ui_left","ui_right")).normalized() 

	elif on_air_time >= 0.2 and !is_on_floor():
		direction =  (abs(Vector2(grav_dir.y,grav_dir.x)) *  Input.get_axis("ui_left","ui_right")).normalized()
	if on_wave != null:
		on_wave_dir = (Vector2(Input.get_axis("ui_left", "ui_right"),Input.get_axis("ui_up", "ui_down")).normalized() + on_wave.lin_veloc.normalized()).normalized()

func _physics_process(delta: float) -> void:
	
	move_and_slide()

func move(direct,modifier):
		if (direct.length()) > 0.0:
			if (((velocity-(grav_dir*velocity.length())).length()) <  MAX_SPEED) and faling || (velocity.length()) <  MAX_SPEED :

					velocity += ((direct) * INITIAL_SPEED) *modifier
			else:
				if abs(modifier) == 1 and (velocity.normalized() - direct.normalized()).length() >1:

						velocity += direct * INITIAL_SPEED *modifier
					
				elif !(statemachine.state is jumpin) and !(statemachine.state is falling):

						velocity = (direct * MAX_SPEED ) *modifier +  Vector2(0,Input.get_action_strength("ui_down")) * MAX_SPEED
		else:
			if on_air_time > 0.2:
				velocity -= abs(Vector2(grav_dir.y,grav_dir.x))*  velocity /75
			else:
				velocity -=  velocity /75
			
func summon_wave(normal,recorded_velocity,player_last_position):
	#print((saved_velocity* normal))
	var additional_velocity : Vector2
	var new_wave = original_wave.instantiate().duplicate()
	new_wave.origin_summon = "Player"
	new_wave.global_position = player_last_position + normal* 2#=  no_contact_list[i].global_position - lin_veloc.normalized()*16 # - 2.5* Vector2(cos(gotofloor.rotation + deg_to_rad(90)),sin(gotofloor.rotation + deg_to_rad(90))) 
	new_wave.rotation = normal.angle() + deg_to_rad(90)#(-lin_veloc).angle()
	if recorded_velocity.length() > 1440:
		recorded_velocity *= 1440/recorded_velocity.length()
	new_wave.size = 16 +(recorded_velocity* normal).length() / 16
	if abs(normal.x) > abs(normal.y):
		additional_velocity = -(JUMP_VELOCITY/2.5) * -Vector2(normal.y,normal.x)
	if !(statemachine.old_state is dash):
		new_wave.lin_veloc =  (recorded_velocity  * -Vector2(normal.y,normal.x))+ additional_velocity
	else:
		new_wave.lin_veloc =  (recorded_velocity  * -Vector2(normal.y,normal.x)) + additional_velocity #d+ Vector2(0,Input.get_action_strength("ui_down")) * MAX_SPEED/2
	get_parent().add_child(new_wave)
	#dddnew_wave.apply_impulse(velocity)
	pass


func _on_area_2d_body_entered(body: fish) -> void:
	if body.on_air_time > 0.2 || body.statemachine.state is on_wave_enemy || body.was_hit > 0:

		if Input.is_action_pressed("ui_down"):
			body.velocity += velocity/2 - (velocity.length() * grav_dir)
			print("poundin")
		else:
			body.velocity += velocity/2 - JUMP_VELOCITY * grav_dir
		body.was_hit = 1.5
		print("yo")
	pass # Replace with function body.
