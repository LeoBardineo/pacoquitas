extends Node2D

@export var nome : String
@export var dialogue_bg_color : Color

func _ready():
	var dict = {
		"node": self,
		"dialogue_bg_color": dialogue_bg_color
	}
	DialogueManager.insert_char(nome, dict)
