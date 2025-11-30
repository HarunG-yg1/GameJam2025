extends Node

@onready var audio_stream_group = self.get_children()
#func _ready() -> void:
func get_playsound(audio_path,play_pos):
	for i in audio_stream_group:
		if !i.playing:
			i.stream = load(audio_path)
			i.playing = true
			break
