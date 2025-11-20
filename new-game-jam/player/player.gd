class_name Player
extends CharacterBody2D

var direction : Vector2
var mark : float 
var original_wave = preload("res://wave/wave.tscn")
var on_wave_dir
var on_wave : Wave
const INITIAL_SPEED = 55.0
const MAX_SPEED = 300.0
#const SPEED = 300.0
const JUMP_VELOCITY = 400

var falling := false
var jumping : bool = false
var hit_timer := 0.25
var hitting := false
var run = false
var finish_run = true

var grav_dir := Vector2(0,1)
@onready var sprite = $Sprite2D

@onready var statemachine = $statemachine
func _ready() -> void:
	
	statemachine.player = self
	statemachine.init()

func _process(delta: float) -> void:
	#if on_wave != null:

	if Input.is_action_just_pressed("dash") and finish_run and !run and velocity.length()>1:
		run = true
		finish_run = false
		await get_tree().create_timer(1).timeout
		run = false

	if not is_on_floor():
		#print(velocity.y)
		velocity += get_gravity()*1.2 * delta #+ Vector2(0,Input.get_axis("ui_accept","ui_down")) * MAX_SPEED/25
		if velocity.y > 0:
			if mark > position.y:
				
				mark -= position.y
				#print(mark)
			velocity += Vector2(0,Input.get_action_strength("ui_down")) * MAX_SPEED/2
			
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !falling:
		jumping = true
		mark = position.y
		
	if Input.is_action_just_pressed("hit") and hit_timer >= 0.25:
		hitting = true
		hit_timer = 0
		
		
	if hit_timer < 0.25 and hitting:
		
			#print(get_last_slide_collision().get_normal())

		hit_timer += delta
	elif hit_timer >= 0.25 and hitting:
		hitting = false
	direction = Vector2(Input.get_axis("ui_left", "ui_right"),0)
func _physics_process(delta: float) -> void:
	

	move_and_slide()

func move(direct,modifier):
		if (direct.length()) > 0.0:
			if (((velocity-(grav_dir*velocity.length())).length()) <  MAX_SPEED) and falling || (velocity.length()) <  MAX_SPEED :
				velocity += (direct * INITIAL_SPEED) *modifier
			else:
				if abs(modifier) == 1 and (abs(velocity.angle() - direct.angle()) < deg_to_rad(90) || abs(velocity.angle() - direct.angle()) > deg_to_rad(270)):
					velocity +=  Vector2(0,0)

				elif statemachine.state != "jumpin":
					print("nigger")
					print(rad_to_deg(abs(velocity.angle() - direct.angle())))
					velocity = (direct * MAX_SPEED ) *modifier +  Vector2(0,Input.get_action_strength("ui_down")) * MAX_SPEED
		#	velocity.x = direction.x * SPEED * modifier
		else:
			velocity.x = move_toward(velocity.x, 0, INITIAL_SPEED)
			
func summon_wave(normal,recorded_velocity,player_last_position):
	#print((saved_velocity* normal))
	var additional_velocity : Vector2
	var new_wave = original_wave.instantiate().duplicate()
	
	new_wave.global_position = player_last_position + normal* 2#=  no_contact_list[i].global_position - lin_veloc.normalized()*16 # - 2.5* Vector2(cos(gotofloor.rotation + deg_to_rad(90)),sin(gotofloor.rotation + deg_to_rad(90))) 
	new_wave.rotation = normal.angle() + deg_to_rad(90)#(-lin_veloc).angle()
	new_wave.size = 16 +(recorded_velocity* normal).length() / 16
	if abs(normal.x) > abs(normal.y):
		additional_velocity = -(JUMP_VELOCITY/2.5) * -Vector2(normal.y,normal.x)
	if statemachine.old_state != "dash":
		new_wave.lin_veloc =  (recorded_velocity  * -Vector2(normal.y,normal.x))+ additional_velocity
	else:
		new_wave.lin_veloc =  (recorded_velocity  * -Vector2(normal.y,normal.x) * .8) + additional_velocity #d+ Vector2(0,Input.get_action_strength("ui_down")) * MAX_SPEED/2
	get_parent().add_child(new_wave)
	#dddnew_wave.apply_impulse(velocity)
	pass
