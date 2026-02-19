extends Control

@onready var panel = $PanelContainer
@onready var label = $PanelContainer/MarginContainer/RichTextLabel
@onready var opcoes_container = $PanelContainer/MarginContainer/OpcoesContainer

signal escolha_feita(index: int)

func spawn(text: String, spawn_pos: Vector2):
	position = spawn_pos
	label.text = text
	opcoes_container.visible = false

func exibir_escolhas(choices: Array, spawn_pos: Vector2):
	position = spawn_pos
	opcoes_container.visible = true
	label.visible = false
	for child in opcoes_container.get_children():
		child.queue_free()
	
	for choice in choices:
		var button = Button.new()
		button.text = choice.Text
		button.pressed.connect(_on_button_pressed.bind(choice.Index))
		opcoes_container.add_child(button)
	

func _on_button_pressed(index: int):
	escolha_feita.emit(index)
