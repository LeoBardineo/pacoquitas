extends Node2D

@export var beat : AudioStream

func _ready():
	AudioManager.tocar_musica(beat, false)
	AudioManager.music_player.finished.connect(_on_beat_finish)

func _on_beat_finish():
	DialogueManager.dar_carimbo = true
	AudioManager.music_player.finished.disconnect(_on_beat_finish)
	Transicao.transicionar_com_dialogo("res://scenes/quarto.tscn", "res://ink/final/Enzo Gabriel.ink", "questmatheus_3")
