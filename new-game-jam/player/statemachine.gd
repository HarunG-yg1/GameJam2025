class_name PlayerStateMachine
extends Node
#var state_action
#var states_ref_counted : Array
var inState_time : float
@export var states : Array
@export  var state  = load("res://player/states/idle.gd")
var old_state = null

var player 


func init() -> void:
	self.process_mode = Node.PROCESS_MODE_INHERIT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state is not GDScript:
		inState_time += delta
		$"../Label".text = str(state.name)
	state_enterer(state)
	if state != null:
		
		change_state(state.Process(delta))
		
	pass

func state_enterer(state_here:RefCounted):
	if state_here is GDScript:
		state= state_here.new()
		
	state.get_GuynStatemachine(self.player,self)
	
func change_state(new_state):

	if new_state == null || new_state == state || (new_state not in states and new_state is GDScript):
		
		return
	
	old_state = state
	state.Exit()
	state = new_state
	state_enterer(new_state)
	state.Enter()
	inState_time = 0
