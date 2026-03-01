extends Node2D

@export var musica : AudioStream

func _ready():
	AudioManager.tocar_musica(musica)
