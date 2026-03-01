extends Node2D

@onready var beat : AudioStreamPlayer2D = $"PaçocaBeatDemo"

func _ready():
	beat.finished.connect(_on_beat_finish)

func _on_beat_finish():
	DialogueManager.dar_carimbo = true
	Transicao.transicionar_com_dialogo("res://scenes/quarto.tscn", "res://ink/final/Enzo Gabriel.ink", "questmatheus_3")
	pass
