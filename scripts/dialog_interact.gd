extends CharacterBody2D

@export var story : InkStory
@export var nome : String
@export var dialogue_bg_color : Color
@export var outline_color : Color

func _ready():
	var dict = {
		"node": self,
		"dialogue_bg_color": dialogue_bg_color,
		"outline_color": outline_color
	}
	DialogueManager.insert_char(nome, dict)
	
	if story == null:
		printerr("não tem .ink associado ao personagem " + self.name)
		return

func _on_area_2d_body_entered(body):
	if(body.is_in_group("Player")):
		print('player entrou na area')
		body.insert_interactable(self)


func _on_area_2d_body_exited(body):
	if(body.is_in_group("Player")):
		print('player saiu da area')
		body.remove_interactable(self)
