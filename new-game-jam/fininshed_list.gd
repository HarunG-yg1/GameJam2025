extends Node
var fish_caught : int
var time : float
var successful : bool = false
var started : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started:
		time += delta
	pass

func restart():
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://menu.tscn")
	successful = false
	started  = false
