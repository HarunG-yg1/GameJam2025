extends Node
@export var hp_owner : Node
@export var hp : int =  20
@export var drown_time : float
var damaged_timer : float
var MAX_DROWN : float 
var MAX_HP : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MAX_HP = hp
	MAX_DROWN = drown_time
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if damaged_timer > 0:
		damaged_timer -= delta
	
	if drown_time < 0:
		drown_time = 1.5
		hp -= 1
		
	pass

func take_damage(dmg:int,time_out: float):
	hp -= dmg
	damaged_timer = time_out
