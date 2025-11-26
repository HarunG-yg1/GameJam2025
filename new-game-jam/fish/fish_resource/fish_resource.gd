class_name Fish_settings extends Resource

@export var fish_type : String
@export var states : Array
@export var MAX_SPEED = 300.0
@export var JUMP_VELOCITY = 400
@export var max_wave_invulnerability_time : float = 4
@export var scale : Vector2 = Vector2(1,1)
@export var dir_int : int = -1
@export var chase_stamina : float = 4
@export var weight_priority : int
@export var texture : Texture2D

func mass_export(the_fish):
	the_fish.fish_type = fish_type
	the_fish.states = states
	the_fish.MAX_SPEED = MAX_SPEED
	the_fish.JUMP_VELOCITY = JUMP_VELOCITY
	the_fish.max_wave_invulnerability_time = max_wave_invulnerability_time
	the_fish.scale = scale
	the_fish.dir_int = dir_int 
	the_fish.chase_stamina = chase_stamina
	the_fish.weight_priority = weight_priority
	the_fish.sprite2 = texture
