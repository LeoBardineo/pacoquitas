extends Node2D

@export var story_resource : InkStory

@onready var dialogbox_scene : PackedScene = preload("res://components/DialogBox.tscn")
@onready var char_node_map = {
	"Benicio": {
		"node": $Benicio,
		"bg_color": ""
	},
	"Lena": {
		"node": $Lena,
		"bg_color": ""
	}
}

var story : InkStory
var dialogbox_atual : Control = null
var interagindo : bool = false
var char_node : Node2D = null

func _ready():
	story = story_resource

func _unhandled_input(event):
	if story == null: return
	if event.is_action_pressed("ui_accept"):
		if story.GetCurrentChoices().size() > 0:
			return
		if dialogbox_atual != null:
			dialogbox_atual.queue_free()
			dialogbox_atual = null
		proximo()
		

func iniciar(ink_story: InkStory):
	story = ink_story
	proximo()

func proximo():
	interagindo = true
	
	var text : String
	if(story.GetCanContinue()):
		text = story.Continue()
	
	var tags : Array[String] = story.GetCurrentTags()
	if tags.size() > 0:
		var char_name : String = tags[0].strip_edges()
		if char_node_map.has(char_name):
			char_node = char_node_map[char_name]["node"]
	
	if char_node == null:
		printerr("ERRO: Nenhuma tag de personagem definida para a linha atual")
		return
	
	if story.GetCurrentChoices().size() > 0:
		instantiate_bubble(text, char_node, true)
		print('escolha')
	elif story.GetCanContinue():
		instantiate_bubble(text, char_node, false)
		print('proxima fala')
	

func instantiate_bubble(text: String, target_node: Node2D, escolher: bool):
	var dialogbox = dialogbox_scene.instantiate()
	add_child(dialogbox)
	
	var spawn_pos = target_node.global_position
	if target_node.has_node("DialogMarker"):
		spawn_pos = target_node.get_node("DialogMarker").global_position
	
	dialogbox_atual = dialogbox
	
	if(!escolher):
		dialogbox.spawn(text, spawn_pos)
	else:
		dialogbox_atual.position = spawn_pos
		mostrar_escolhas()

func mostrar_escolhas():
	var opcoes_container = dialogbox_atual.opcoes_container
	var label = dialogbox_atual.label
	
	for child in opcoes_container.get_children():
		child.queue_free()
		
	opcoes_container.visible = true
	label.visible = false
	
	for choice in story.GetCurrentChoices():
		var escolha_nova = Button.new()
		escolha_nova.text = choice.Text
		escolha_nova.pressed.connect(_on_choice_selected.bind(choice.Index))
		opcoes_container.add_child(escolha_nova)

func _on_choice_selected(index: int):
	print('clicou no botão')
	story.ChooseChoiceIndex(index)
	if(story.GetCanContinue()):
		if dialogbox_atual != null:
			dialogbox_atual.queue_free()
			dialogbox_atual = null
		proximo()
	else:
		print('fim após escolha')
		if dialogbox_atual != null:
			dialogbox_atual.queue_free()
