extends Control


@export var to_scene : String = ("res://main_game.tscn")
func _ready() -> void:
	$Label.text = "Time taken : " + str("%.2f" %Finish.time)  + "seconds \nFish caught : " +str(Finish.fish_caught) + "\nAlive : " +str(Finish.successful)
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(to_scene)
	Finish.fish_caught = 0
	Finish.time = 0.0
	pass # Replace with function body.
