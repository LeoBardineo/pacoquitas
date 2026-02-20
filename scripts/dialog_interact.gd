extends Area2D

@export var story : InkStory
@onready var interact_warn : PackedScene = preload("res://components/Interact.tscn")
@onready var interact_node = interact_warn.instantiate()
@onready var interact_position = get_parent().get_node("DialogMarker").position

func _ready():
	if story == null:
		printerr("não tem .ink associado ao personagem " + self.name)
		return
	add_child(interact_node)
	interact_node.visible = false
	interact_node.position = interact_position

func _unhandled_input(event):
	if(!DialogueManager.on_area || DialogueManager.interagindo): return
	if event.is_action_released("interaction"):
		DialogueManager.iniciar(story)
		interact_node.visible = false

func _on_body_entered(area):
	if(area.is_in_group("Player")):
		print('player entrou na area')
		interact_node.visible = true
		DialogueManager.on_area = true
	

func _on_body_exited(area):
	if(area.is_in_group("Player")):
		print('player saiu da area')
		interact_node.visible = false
		DialogueManager.on_area = false
	
