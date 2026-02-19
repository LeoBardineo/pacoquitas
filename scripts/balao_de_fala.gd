extends Control

@export var story : InkStory

@onready var fala_container : HBoxContainer = $DialogoContainer/MarginContainer/FalaContainer
@onready var name_label : RichTextLabel = $DialogoContainer/MarginContainer/FalaContainer/MarginContainer/VBoxContainer/Nome
@onready var texto_label : RichTextLabel = $DialogoContainer/MarginContainer/FalaContainer/MarginContainer/VBoxContainer/Texto
@onready var opcoes_container : VBoxContainer = $DialogoContainer/MarginContainer/OpcoesContainer

var escolha_exemplo : Button = null

func _ready():
	exibir_falas()
	avancar_timeline()
	
func _unhandled_input(event):
	if(event.is_action_pressed("ui_accept")):
		if(story.GetCanContinue()):
			avancar_timeline()
		elif(story.GetCurrentChoices().is_empty()):
			print('fim da história')
			queue_free()

func avancar_timeline():
	if(story.GetCanContinue()):
		texto_label.text = story.Continue()
	
	var tags = story.GetCurrentTags()
	if(tags.size() > 0):
		name_label.text = tags[0]
	
	if(story.GetCurrentChoices().size() > 0):
		mostrar_escolhas()
	else:
		exibir_falas()

func mostrar_escolhas():
	for child in opcoes_container.get_children():
		child.queue_free()
	exibir_escolhas()
	for choice in story.GetCurrentChoices():
		var escolha_nova = Button.new()
		if escolha_exemplo:
			escolha_nova =  escolha_exemplo.instantiate()
		escolha_nova.text = choice.Text
		escolha_nova.pressed.connect(_on_choice_selected.bind(choice.Index))
		opcoes_container.add_child(escolha_nova)

func _on_choice_selected(index: int):
	print('clicou no botão')
	story.ChooseChoiceIndex(index)
	exibir_falas()
	if(story.GetCanContinue()):
		avancar_timeline()
	else:
		print('fim após escolha')

func exibir_escolhas():
	fala_container.visible = false
	opcoes_container.visible = true
	
func exibir_falas():
	fala_container.visible = true
	opcoes_container.visible = false
