class_name fish
extends CharacterBody2D

var direction : Vector2

var original_wave = preload("res://wave/wave.tscn")

var faling := false
var jumping : bool = false
var on_air_time : float

var sleep_queue : bool = false
var saved_position : Vector2

var run = false
var finish_run = true

var grav_dir := Vector2(0,1)

var recharge_stamina : bool = false

var was_hit : float 
var hitting := false


var wave : Wave = null
var player = null

const INITIAL_SPEED = 55.0

@export var fish_settings : Fish_settings

var classname : String = "fish"
var wave_invulnerability_time : float = 0
var fish_type : String 
var states : Array 
var MAX_SPEED : float
var JUMP_VELOCITY : float 
var max_wave_invulnerability_time : float
var early_sprite_pos : Vector2
var dir_int : int 
var chase_stamina : float
var weight_priority : int 
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var hp_and_stuff = $hp_and_stuff
@onready var sprite = $Sprite2D
@onready var detect_area =$Area2D
@onready var statemachine =  $statemachine

func _ready() -> void:
	
	early_sprite_pos = sprite.position
	fish_settings.mass_export(self)
	statemachine.enemy = self
	statemachine.init(states)
	animated_sprite.play("default")

func _process(delta: float) -> void:
	if sleep_queue and on_air_time == 0 and statemachine.state is not attack_enemy and statemachine.state is not falling_enemy:
		
		statemachine.set_process(false)
		set_process(false)
		velocity *= 0
		saved_position = position
		collision.disabled = true

		

		
	if was_hit > 0:
		was_hit -= delta
	
	if wave_invulnerability_time > 0:
		wave_invulnerability_time -= delta
	if recharge_stamina and chase_stamina < 4:
		
		chase_stamina += delta
	else:
		
		recharge_stamina = false
	if chase_stamina <= 0 and !recharge_stamina:
		recharge_stamina = true
	detect_area.rotation = velocity.angle()
	if is_on_floor():
		if on_air_time != 0:
			displace_32pix_below()
		on_air_time = 0
	else:
		if on_air_time <= 0:
			bring_sprite_to_center()
		on_air_time += delta
	
	if on_air_time < 0.2 and is_on_floor():
		
		direction =( (Vector2(cos(get_floor_normal().angle() + deg_to_rad(90)),sin(get_floor_normal().angle() + deg_to_rad(90))) )* dir_int).normalized() 
	#	print(direction)
	elif on_air_time > 0.2 and !is_on_floor():
		
		direction =  abs(Vector2(grav_dir.y,grav_dir.x)) * dir_int 
	sprite.rotation = Vector2(abs(velocity.x),velocity.y).angle()
	sprite.scale.x = dir_int * abs(sprite.scale.x)
	#	print(on_wave_dir)
func _physics_process(delta: float) -> void:
	move_and_slide()

func move(direct,modifier):
		if (direct.length()) > 0.0:
			if ((velocity-(grav_dir*velocity.length())).length() <  MAX_SPEED and faling || velocity.length() <  MAX_SPEED) ||  abs(modifier) == 1 and (velocity.normalized() - direct.normalized()).length() >1.44:
		#	if (((velocity-(grav_dir*velocity.length())).length()) <  MAX_SPEED) and statemachine.state is falling_enemy || (velocity.length()) <  MAX_SPEED :

				velocity += ((direct) * INITIAL_SPEED) *modifier
			else:

				if (statemachine.state is not jumpin_enemy and  statemachine.state is not attack_enemy and statemachine.state is not falling_enemy)||statemachine.state is attack_enemy2 :
					if on_air_time < 0.2:
						velocity = (direct * MAX_SPEED ) *modifier + grav_dir  #+  Vector2(0,Input.get_action_strength("ui_down")) * MAX_SPEED
					else:
						velocity = (direct * MAX_SPEED ) *modifier 
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

func bring_sprite_to_center():
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(sprite,"position",Vector2(0,0),0.75)
	await tween.finished
	tween.kill()

func displace_32pix_below():
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(sprite,"position",early_sprite_pos,0.75)
	await tween.finished
	tween.kill()
	

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	sleep_queue = true
	




func _on_visible_on_screen_enabler_2d_screen_entered() -> void:

		sleep_queue = false
		if saved_position != Vector2.ZERO:
			position = saved_position 
			saved_position = Vector2.ZERO
		statemachine.set_process(true)
		set_process(true)
		collision.disabled = false
	#	visible = true

func tween_get_hurt(the_sprite):
	var tween = get_tree().create_tween()
	tween.tween_property(the_sprite,"modulate",Color.RED,.15)
	
	tween.tween_property(the_sprite,"modulate",Color.WHITE,.15)
	await tween.finished
	tween.kill()

func die():
	await get_tree().create_timer(5).timeout
	queue_free()
