extends Node2D

func _ready():
	DialogueManager.dialogo_terminou.connect(final)

func final():
	Transicao.transicionar("res://scenes/minigames/minigame_final.tscn")
	pass
