extends Area2D

@export var story : InkStory
@onready var interact_warn : PackedScene = preload("res://components/Interact.tscn")
@onready var interact_node = interact_warn.instantiate()

var on_area = false

func _ready():
	add_child(interact_node)
	interact_node.visible = false
	interact_node.position = position # + Vector2(0, -20)

func _unhandled_input(event):
#	if(!on_area || DialogueManager.interagindo): pass
	if event.is_action_pressed("ui_accept"):
		#DialogueManager.iniciar(story)
		interact_node.visible = false

func _on_area_entered(area):
	if(area.is_in_group("Player")):
		print('player entrou na area')
		interact_node.visible = true
		on_area = true
	

func _on_area_exited(area):
	if(area.is_in_group("Player")):
		print('player saiu da area')
		interact_node.visible = false
		on_area = false
	
