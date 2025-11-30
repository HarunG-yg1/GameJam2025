class_name enemystatemachine
extends Node
#var state_action
var states : Array
@export var state  = load("res://fish/states/idle_e.gd")
var old_state
var inState_time : float
var enemy
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func init(state_array) -> void:
	states = state_array
	self.process_mode = Node.PROCESS_MODE_INHERIT
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state is not GDScript:
		inState_time += delta
		
	state_enterer(state)
	if state != null:
		
		change_state(state.Process(delta))


func state_enterer(state_here):
	
	if state is GDScript:
		state= state.new()
	state.enemy = self.enemy
	state.state_machine = self

func change_state(new_state):
	
	if new_state == null || new_state == state ||(new_state not in states and new_state is GDScript):
		return
	state.Exit()
	old_state = state
	state = new_state
	state_enterer(new_state)
	state.Enter()
	inState_time = 0






	







	
