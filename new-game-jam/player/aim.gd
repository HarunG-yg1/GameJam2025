extends Sprite2D
var swing_speed : Vector2
var origin_mouse : Vector2
var period : float
var harpoon : bool = false
var release_time : float = 3
var aim_to_cursor : Vector2
@onready var hurt_box = $"../Area2D"
@onready var player = $".."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_cursor_speed_for_smash(delta)
	aim_to_cursor =  ( get_global_mouse_position()- player.position).normalized()
	hurt_box.rotation = aim_to_cursor.angle()
	if release_time < 3:
		release_time += delta
		if release_time > 0.15:
			swing_speed *= 0
			harpoon = false
	if Input.is_action_pressed("hit") and release_time >=2.5:
		swing_speed -= swing_speed * delta/7.5
		
		if swing_speed.length() < 150:
			visible = false
		else:
			visible = true
		rotation = aim_to_cursor.angle()
		

	if Input.is_action_just_released("hit") and swing_speed.length() > 150 and release_time >=2.5:
		visible = false
		harpoon = true
		release_time = 0
	
	pass


func check_cursor_speed_for_smash(delta:float):
	if origin_mouse == Vector2.ZERO:
		origin_mouse = get_global_mouse_position()
	period -= delta
	if period <= 0:
		period = 0.05
		if (origin_mouse - get_global_mouse_position()).length() > 150:
			swing_speed = -(origin_mouse - get_global_mouse_position())
		origin_mouse = Vector2.ZERO
