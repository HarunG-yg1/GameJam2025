extends RayCast2D
var spawn := true
var die := false
var order : int = 0
var hitted := false
@onready var gotofloor = $"../../gotofloor"
@export var floor_check := false
signal collide
signal uncollide
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_exception($"../..")
	add_exception(%CharacterBody2D)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (get_collider() is TileMapLayer || get_collider() is Wave) and !hitted:
		emit_signal("collide",self,get_collision_normal(),get_collider())
		if !floor_check and gotofloor.is_onfloor:
			hitted = true
		elif floor_check:
			hitted = true

	elif hitted and !is_colliding():
		if floor_check:
	
			hitted = false
			emit_signal("uncollide",self,get_collision_normal())
