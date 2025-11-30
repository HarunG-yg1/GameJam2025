class_name hp_n_stuff

extends Node
@export var hp_owner : Node
@export var hp : float=  20
@onready var hp_bar = %ProgressBar
var damaged_timer : float
var heal_timer : float
var drown_time : float = 0.8
var MAX_HP : float
var fishes : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MAX_HP = hp
	hp_bar.value = 100
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hp_owner is Player and Input.is_action_just_pressed("eat"):
		eat_fish()
	if heal_timer > 0:
		heal_timer -= delta
	if damaged_timer > 0:
		damaged_timer -= delta
	


func take_damage(dmg:int,time_out: float):
	hp_owner.tween_get_hurt(hp_owner.sprite)
	
	if damaged_timer <= 0:
		hp -= dmg
		damaged_timer = time_out
		hp_bar.value =(hp/MAX_HP) * 100


func eat_fish():
	if fishes >0 and heal_timer <= 0:
		heal_timer = 1
		fishes -= 1
		hp += 2
		hp_bar.value =(hp/MAX_HP) * 100
		drown_time = 0.8
		print("fishes"+str(fishes))

func drown(in_water_time):
	#print(drown_time)
	if drown_time > 0:
		drown_time -= in_water_time
	elif drown_time <= 0:
		take_damage(1,1)
		drown_time = 0.8
