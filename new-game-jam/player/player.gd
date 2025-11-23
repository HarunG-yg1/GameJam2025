class_name Player
extends CharacterBody2D
var on_wave_dir : Vector2
var direction : Vector2
var mark : float 
var original_wave = preload("res://wave/wave.tscn")

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

	if not is_on_floor() and on_wave == null:
		
		velocity += (grav_dir) * Input.get_action_strength("ui_down") * MAX_SPEED/5
			
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and !falling and !jumping:
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
	if is_on_floor():
		direction =( Vector2(cos(get_floor_normal().angle() + deg_to_rad(90)),sin(get_floor_normal().angle() + deg_to_rad(90))) * Input.get_axis("ui_left",("ui_right"))).normalized() 
	#if on_wave != null:
	else:
		direction = Vector2(Input.get_axis("ui_left", "ui_right"),0).normalized() 
	if on_wave != null:
		on_wave_dir = (Vector2(Input.get_axis("ui_left", "ui_right"),Input.get_axis("ui_up", "ui_down")).normalized() + on_wave.lin_veloc.normalized()).normalized()
	#	print(on_wave_dir)
func _physics_process(delta: float) -> void:
	

	move_and_slide()

func move(direct,modifier):
		#print("miggamigga")
		#print((direct.normalized() - grav_dir).length() )
		
		if (direct.length()) > 0.0:
			if (((velocity-(grav_dir*velocity.length())).length()) <  MAX_SPEED) and falling || (velocity.length()) <  MAX_SPEED :
				if is_on_floor() and (direct.normalized() - grav_dir).length() <= 1.533 and !jumping and !falling:
					
					velocity += ((direct + grav_dir).normalized() * INITIAL_SPEED) *modifier
					#print((direct + grav_dir).normalized() * INITIAL_SPEED)
					
				else:
					
					velocity += ((direct) * INITIAL_SPEED) *modifier
			else:
				if abs(modifier) == 1 and (velocity.normalized() - direct.normalized()).length() >1:
					
					if is_on_floor() and (direct.normalized() - grav_dir).length() <= 1.533 and !jumping and !falling:
						
	
						velocity += (grav_dir) * 4 * INITIAL_SPEED *modifier
					#a	print((direct.normalized() - grav_dir).length())
					#	JUMP_VELOCITY = 400
					else:
						#dprint(statemachine.state)
						velocity += direct * INITIAL_SPEED *modifier
					

				elif statemachine.state != "jumpin" and statemachine.state != "falling":
				#	print(statemachine.state)
					#print(rad_to_deg(abs(velocity.angle() - direct.angle())))
		
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
		new_wave.lin_veloc =  (recorded_velocity  * -Vector2(normal.y,normal.x)) + additional_velocity #d+ Vector2(0,Input.get_action_strength("ui_down")) * MAX_SPEED/2
	get_parent().add_child(new_wave)
	#dddnew_wave.apply_impulse(velocity)
	pass
