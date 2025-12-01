class_name hp_n_stuff

extends Node
var pitch : float = 1
@export var hp_owner : Node
@export var hp : float=  20
@onready var labels = $Label
@onready var hp_bar = %HP_bar
@onready var audioPlayer = %AudioStreamPlayer
@onready var multiplier_bar = $"../CanvasGroup/Cool_Meter"
@onready var cool_label_multiplier = $CoolLabel
@onready var fish_label = $fish_label
var multiplier : float = 1
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
	if multiplier > 1 and hp_owner is Player:
		cool_label_multiplier.text = str("%.2f" % (multiplier)) + "x  FISHTASTIC"
		multiplier -= delta/10
		multiplier_bar.value = ((multiplier -1)/multiplier) * 100
	elif hp_owner is Player:
		cool_label_multiplier.text = ""
	if hp_owner is Player and Input.is_action_just_pressed("eat"):
		eat_fish()
	if heal_timer > 0:
		heal_timer -= delta
	if damaged_timer > 0:
		damaged_timer -= delta
	
func play_state_and_hurt_sound(audio_path:String,start_time:float = 0.0,pitch:float = 1,volume:float = 1):
			audioPlayer.volume_linear = volume
			audioPlayer.pitch_scale = pitch
			audioPlayer.stream = load(audio_path)
			audioPlayer.play(start_time)
func take_damage(dmg:int,time_out: float):
	
	
	if damaged_timer <= 0:
		hp_owner.tween_get_hurt(hp_owner.sprite)
		#hp_label = str(hp_bar.value)
		play_state_and_hurt_sound("res://sfx/some cruelty squad sfx2.mp3",0.73,pitch)

		hp -= dmg
		damaged_timer = time_out
		hp_bar.value =(hp/MAX_HP) * 100
	#	hp_label.text = str(hp_bar.value) + "% HP"


func eat_fish():
	if fishes >0 and heal_timer <= 0 and hp < MAX_HP:
		Playsound.get_playsound("res://sfx/Minecraft eating sound effect.mp3",hp_owner.position,0,randf_range(0.8,1.6),0.6)
		heal_timer = 1
		fishes -= 1
		if (hp + 2 * multiplier) < MAX_HP:
			hp += 2 * multiplier
		else:
			hp = MAX_HP
		hp_bar.value =(hp/MAX_HP) * 100
		#hp_label.text = str(hp_bar.value) + "% HP"
		drown_time = 0.8
		fish_label.text = "Fishes :" + str(fishes)
		#print("fishes"+str(fishes))

func drown(in_water_time):
	#print(drown_time)
	if drown_time > 0:
		drown_time -= in_water_time
	elif drown_time <= 0:
		take_damage(1,1)
		drown_time = 0.8
