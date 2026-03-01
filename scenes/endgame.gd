extends CanvasLayer

@export var ink_story : InkStory

func _ready():
	DialogueManager.on_area = true
	DialogueManager.area_final = true
	DialogueManager.iniciar(ink_story, false)
	DialogueManager.dialogo_terminou.connect(_on_terminou)

func _on_terminou():
	DialogueManager.area_final = false
	DialogueManager.on_area = false

func _on_button_pressed():
	Transicao.transicionar("res://scenes/inicio.tscn")
