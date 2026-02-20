extends CharacterBody2D

@export var story : InkStory
@export var nome : String
@export var bg_color : Color

@onready var interact_warn : PackedScene = preload("res://components/Interact.tscn")
@onready var interact_node = interact_warn.instantiate()
@onready var interact_position = $DialogMarker.position

func _ready():
	var dict = {
		"node": self,
		"bg_color": bg_color
	}
	DialogueManager.insert_char(nome, dict)
	
	if story == null:
		printerr("não tem .ink associado ao personagem " + self.name)
		return
	add_child(interact_node)
	interact_node.visible = false
	interact_node.position = interact_position

func _on_area_2d_body_entered(body):
	if(body.is_in_group("Player")):
		print('player entrou na area')
		body.insert_interactable(self)


func _on_area_2d_body_exited(body):
	if(body.is_in_group("Player")):
		print('player saiu da area')
		body.remove_interactable(self)
