extends Node

@onready var audio_stream_group = self.get_children()
#func _ready() -> void:
func get_playsound(audio_path:String,play_pos:Vector2,start_time:float = 0.0,pitch:float = 1,volume = 1):
	for i in audio_stream_group:
		if !i.playing:
			i.volume_linear = volume
			i.position = play_pos
			i.pitch_scale = pitch
			i.stream = load(audio_path)
			i.play(start_time)
			break
