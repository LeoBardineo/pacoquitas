extends Node

@export var nome : String
@export var bg_color : Color

func _ready():
	var dict = {
		"node": self,
		"bg_color": bg_color
	}
	DialogueManager.insert_char(nome, dict)
