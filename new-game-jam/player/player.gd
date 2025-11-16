extends CharacterBody2D

var direction : Vector2
var mark : float 
const SPEED = 300.0
const JUMP_VELOCITY = -400


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		#print(velocity.y)
		velocity += get_gravity()*1.2 * delta + Vector2(0,Input.get_axis("ui_accept","ui_down")) * SPEED/25
		if velocity.y > 0:
			if mark > position.y:
				
				mark -= position.y
				#print(mark)
			velocity += Vector2(0,Input.get_action_strength("ui_down")) * SPEED/5

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		mark = position.y
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction.x = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
