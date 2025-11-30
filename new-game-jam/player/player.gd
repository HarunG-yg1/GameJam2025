class_name Player
extends CharacterBody2D
var on_wave_dir : Vector2
var direction : Vector2
var last_dir : Vector2 = Vector2.RIGHT

var full_state_name : String = "idle_right"
var hit_count : int = 1

var original_wave = preload("res://wave/wave.tscn")
var hit_targets : Array[fish]
var on_wave : Wave
const INITIAL_SPEED = 55.0
const MAX_SPEED = 300.
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
@onready var collision = $CollisionShape2D
@onready var hp_and_stuff =$hp_and_stuff
@onready var aim = $aim
@onready var sprite = $Sprite2D
@onready var hurtbox = $Area2D
@onready var statemachine = $statemachine
func _ready() -> void:
	
	statemachine.player = self
	statemachine.init()
	sprite.play(full_state_name)
func _process(delta: float) -> void:

	drown(delta)
	if Input.is_action_just_pressed("reload"):
		wave_charge = 3
	if wave_charge > 0:
		wave_charge -= delta
	if Input.is_action_just_pressed("dash") and finish_run and !run and velocity.length()>1 and on_wave == null:
		run = true
		finish_run = false
		await get_tree().create_timer(1).timeout
		run = false
		finish_run = true

	if on_air_time > 0.2 and on_wave == null:
		velocity += (grav_dir) * Input.get_action_strength("ui_down") * MAX_SPEED/5

	if Input.is_action_just_pressed("ui_accept") and ((!faling and !jumping and on_air_time < 0.2) || styling):

		jumping = true

	if Input.is_action_just_pressed("ui_accept") and !styling and on_air_time > 0.2:# and (on_wave != null ||statemachine.state is falling and statemachine.old_state is ride_wave):
		styling = true
		await get_tree().create_timer(1).timeout
		styling = false
	if Input.is_action_just_pressed("hit") and hit_timer >= 0.25:
		if hit_count == 1:
			hit_count += 1
		else:
			hit_count -= 1
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


	if statemachine.state is not harpooning and statemachine.state is not ride_wave:
		hurtbox.rotation = direction.angle()
	elif  statemachine.state is not harpooning:
		hurtbox.rotation = abs(velocity.angle())
	else:
		hurtbox.rotation = on_wave_dir.angle()
	
	if on_air_time < 0.2 and is_on_floor():
		direction =( Vector2(cos(get_floor_normal().angle() + deg_to_rad(90)),sin(get_floor_normal().angle() + deg_to_rad(90))) * Input.get_axis("ui_left","ui_right")).normalized() 

	elif on_air_time >= 0.2 and !is_on_floor():
		direction =  (abs(Vector2(grav_dir.y,grav_dir.x)) *  Input.get_axis("ui_left","ui_right")).normalized()

	if on_wave != null:
		on_wave_dir = Vector2(Input.get_axis("ui_left", "ui_right"),Input.get_axis("ui_up", "ui_down")).normalized()
		if last_dir != (abs(Vector2(grav_dir.y,grav_dir.x)) * on_wave_dir).normalized():
			last_dir = (abs(Vector2(grav_dir.y,grav_dir.x)) * on_wave_dir).normalized()
			find_anim(statemachine.state)
		
		sprite.rotation = (on_wave.position - position).angle() - deg_to_rad(90)
	
			
	
func _physics_process(delta: float) -> void:
	
	move_and_slide()

func move(direct,modifier):
		
		if (direct.length()) > 0.0:
			if last_dir != (abs(Vector2(grav_dir.y,grav_dir.x)) * direct).normalized():
				last_dir = (abs(Vector2(grav_dir.y,grav_dir.x)) * direct).normalized()
				find_anim(statemachine.state)
				#print(statemachine.state)
			if ((velocity-(grav_dir*velocity.length())).length() <  MAX_SPEED and faling || velocity.length() <  MAX_SPEED) ||  abs(modifier) == 1 and (velocity.normalized() - direct.normalized()).length() >1.44 :
					
					velocity += ((direct) * INITIAL_SPEED) *modifier
			else:

					
				if !(statemachine.state is jumpin) and !(statemachine.state is falling):

						velocity = (direct * MAX_SPEED ) *modifier +  Vector2(0,Input.get_action_strength("ui_down")) * MAX_SPEED
		else:
			if on_air_time > 0.2:
				#print('yo')
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
	if recorded_velocity.length() > 950:
		recorded_velocity *= 950/recorded_velocity.length()
	new_wave.size = 16 +(recorded_velocity* normal).length() / 16
	if abs(normal.x) > abs(normal.y):
		additional_velocity = -(JUMP_VELOCITY) * -Vector2(normal.y,normal.x)
	#if !(statemachine.old_state is dash):
	#	new_wave.lin_veloc =  (recorded_velocity  * -Vector2(normal.y,normal.x))+ additional_velocity
	#else:
	new_wave.lin_veloc =  (recorded_velocity  * -Vector2(normal.y,normal.x)) + additional_velocity #d+ Vector2(0,Input.get_action_strength("ui_down")) * MAX_SPEED/2
	print(new_wave.lin_veloc)
	get_parent().add_child(new_wave)
	#dddnew_wave.apply_impulse(velocity)
	pass
func hit_at_target():
	for i in hit_targets:
		if i != null and ( i.on_air_time > 0.1 || i.statemachine.state is on_wave_enemy || i.was_hit > 0):
			
			i.hp_and_stuff.take_damage(1*velocity.length()/100,0)
			if i.hp_and_stuff.hp <= 0:
				hp_and_stuff.fishes += i.hp_and_stuff.MAX_HP / 10
				print(hp_and_stuff.fishes)
			if Input.is_action_pressed("ui_down"):
				
				i.velocity += (velocity/2 - (velocity.length() * grav_dir)) * (1/i.weight_priority)
				
			else:
				i.velocity += velocity/2 - JUMP_VELOCITY * grav_dir * (1/i.weight_priority)
			i.was_hit = 1.5
	#if statemachine.state is harpooning and hit_targets.size()>0:
		#velocity *= 0.4
		

func _on_area_2d_body_entered(body: fish) -> void:
	hit_targets.append(body)
	if statemachine.state is harpooning:
		hit_at_target()
		velocity *= 0.4
	
func _on_area_2d_body_exited(body: fish) -> void:
	#if statemachine.state is not harpooning:
		#awa\\pass
	hit_targets.erase(body)
		


func drown(in_water_time):
	if on_wave != null and (on_wave.position - position).length() < on_wave.size/2 and  on_wave.size > 16 and on_wave.lin_veloc.length() > 150 :
		hp_and_stuff.drown(in_water_time)
		
	#else:
	#	hp_and_stuff.drown(-in_water_time/2)
		
func find_anim(the_state):
	#print(the_state.name)
	
	if the_state is not dead:
		if the_state is harpooning:
			last_dir = (abs(Vector2(grav_dir.y,grav_dir.x)) * aim.aim_to_cursor).normalized()
			
			if last_dir == Vector2.LEFT:
				sprite.rotation = aim.aim_to_cursor.angle() - last_dir.angle() - deg_to_rad(45) 
			elif last_dir == Vector2.RIGHT:
				sprite.rotation = aim.aim_to_cursor.angle() - last_dir.angle() + deg_to_rad(45) 
		elif the_state is style and randi_range(1,100) > 70:
			
			tween_do_a_flip(sprite)
		else:
			sprite.rotation = 0
		
		if last_dir == Vector2.LEFT:
			full_state_name = (str(the_state.name)+"_left")
		elif last_dir == Vector2.RIGHT:
			full_state_name = (str(the_state.name)+"_right")
		if the_state is hit:
			full_state_name += ("_"+str(hit_count))
	else:
		full_state_name = str(the_state.name)
		
	#print(full_state_name)
	#sprite.animation = full_state_name
	sprite.play(full_state_name)

func tween_do_a_flip(the_sprite):
	var tween = get_tree().create_tween()
	tween.tween_property(the_sprite,"rotation",deg_to_rad(360),.5)
	await tween.finished
	tween.kill()

func tween_get_hurt(the_sprite):
	var tween = get_tree().create_tween()
	tween.tween_property(the_sprite,"self_modulate",Color.RED,.15)
	
	tween.tween_property(the_sprite,"self_modulate",Color.WHITE,.15)
	await tween.finished
	tween.kill()
