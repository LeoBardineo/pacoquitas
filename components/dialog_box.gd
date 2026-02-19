extends Control

@onready var panel = $PanelContainer
@onready var label = $PanelContainer/MarginContainer/RichTextLabel
@onready var opcoes_container = $PanelContainer/MarginContainer/OpcoesContainer

func spawn(text: String, spawn_pos: Vector2):
	position = spawn_pos
	label.text = text
