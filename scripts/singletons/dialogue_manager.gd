extends Node2D

@onready var dialogbox_scene : PackedScene = preload("res://components/DialogBox.tscn")

var story : InkStory
var dialogbox_atual : Control = null
var interagindo : bool = false
var char_node : Node2D = null
var char_node_map = {}
var char_atual = {}
var on_area = false

signal dialogo_terminou

func _unhandled_input(event):
	if story == null || !on_area : return
	if event.is_action_pressed("ui_cancel"):
		print('resetou')
		return
	if event.is_action_pressed("interaction"):
		get_viewport().set_input_as_handled()
		print("tentando continuar")
		if story.GetCurrentChoices().size() > 0:
			return
		apagar_dialogbox_atual()
		proximo()

func insert_char(char_name: String, char_dict: Dictionary):
	char_node_map[char_name] = char_dict

# usar ao sair de uma cena
func clear_char_map():
	char_node_map.clear()
	char_node = null
	char_atual.clear()

func iniciar(ink_story: InkStory, repetir : bool, knot : String = ""):
	if(ink_story == null):
		return
	story = ink_story
	if(repetir):
		resetar_story()
	if(knot != ""):
		story.ChoosePathString(knot)
	proximo()

func proximo():
	interagindo = true
	
	var text : String = ""
	if(story.GetCanContinue()):
		text = story.Continue()
	
	var tags : Array[String] = story.GetCurrentTags()
	if tags.size() > 0:
		var char_name : String = tags[0].strip_edges()
		if char_node_map.has(char_name):
			char_atual = char_node_map[char_name]
			if(char_atual == null):
				print('personagem encontrado nao adicionado')
				return
			char_node = char_atual["node"]
	
	if char_node == null:
		print('nenhuma tag de personagem definida para a linha atual do ink')
		acabar_dialogo()
		return
	
	if story.GetCurrentChoices().size() > 0:
		instantiate_bubble(text, char_node, true)
		print('escolha')
	elif text != "":
		instantiate_bubble(text, char_node, false)
		print('proxima fala')
	else:
		print('cabou o diálogo')
		acabar_dialogo()

func instantiate_bubble(text: String, target_node: Node2D, escolher: bool):
	var dialogbox = dialogbox_scene.instantiate()
	add_child(dialogbox)
	
	var spawn_pos = target_node.global_position
	if target_node.has_node("DialogMarker"):
		spawn_pos = target_node.get_node("DialogMarker").global_position
	
	var bg_color = Color.BLACK
	if char_atual.has("dialogue_bg_color"):
		bg_color = char_atual["dialogue_bg_color"]
	
	dialogbox_atual = dialogbox
	
	if(!escolher):
		dialogbox.spawn(text, spawn_pos, bg_color)
	else:
		dialogbox.exibir_escolhas(story.GetCurrentChoices(), spawn_pos)
		dialogbox.escolha_feita.connect(_on_choice_selected)

func _on_choice_selected(index: int):
	print('clicou no botão')
	story.ChooseChoiceIndex(index)
	
	apagar_dialogbox_atual()
	
	if(story.GetCanContinue() or story.GetCurrentChoices().size() > 0):
		proximo()
	else:
		print('fim após escolha')
		acabar_dialogo()

func apagar_dialogbox_atual():
	if dialogbox_atual != null:
		dialogbox_atual.queue_free()
		dialogbox_atual = null

func acabar_dialogo():
	apagar_dialogbox_atual()
	dialogo_terminou.emit()
	await get_tree().create_timer(0.1).timeout
	interagindo = false

func resetar_story():
	story.ResetState()

func can_continue(s : InkStory):
	return s.GetCanContinue() || s.GetCurrentChoices().size() > 0
