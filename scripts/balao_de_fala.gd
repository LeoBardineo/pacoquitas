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

#@onready var dialogue_box = $DialogoContainer
#@onready var portrait = $DialogoContainer/MarginContainer/HBoxContainer/Portrait
#@onready var name_label = $DialogoContainer/MarginContainer/HBoxContainer/VBoxContainer/NameLabel
#@onready var dialogue_text = $DialogoContainer/MarginContainer/HBoxContainer/VBoxContainer/DialogueText
#@onready var choices_container = $ChoicesContainer
#
## Sinal para avisar o jogo que uma escolha foi feita
#signal choice_selected(index)
#
#func _ready():
	## Esconde tudo no começo
	#dialogue_box.visible = false
	#choices_container.visible = false
#
## Função para mostrar uma fala nova
#func show_dialogue(character_name: String, text: String, portrait_texture: Texture2D = null):
	#dialogue_box.visible = true
	#choices_container.visible = false # Esconde escolhas antigas/enquanto fala
	#
	## Atualiza visual
	#name_label.text = character_name
	#dialogue_text.text = text
	#portrait.texture = portrait_texture
	#
	## Efeito de Máquina de Escrever (Typewriter)
	#dialogue_text.visible_ratio = 0.0 # Começa invisível
	#
	#var tween = create_tween()
	## Tempo baseado no tamanho do texto (0.05s por letra)
	#var duration = text.length() * 0.05 
	#tween.tween_property(dialogue_text, "visible_ratio", 1.0, duration)
	#
	## Espera o Tween terminar antes de permitir avançar ou mostrar escolhas
	#await tween.finished
#
## Função para criar os botões de escolha
#func show_choices(options: Array):
	## Primeiro, limpa botões antigos
	#for child in choices_container.get_children():
		#child.queue_free()
	#
	#choices_container.visible = true
	#
	## Cria novos botões dinamicamente
	#for i in range(options.size()):
		#var btn = Button.new()
		#btn.text = options[i]
		## Conecta o sinal "pressed" do botão passando o índice dele
		#btn.pressed.connect(_on_button_pressed.bind(i))
		#choices_container.add_child(btn)
#
## Quando o jogador clica num botão
#func _on_button_pressed(index):
	#choices_container.visible = false
	#dialogue_box.visible = false # Opcional: fechar caixa ao escolher
	#emit_signal("choice_selected", index)
