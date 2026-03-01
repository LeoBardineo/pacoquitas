extends CanvasLayer

@export var ink_story : InkStory

func _ready():
	print("tentando começar endgame")
	DialogueManager.dialogo_terminou.connect(_on_terminou)

func _on_terminou():
	print("fim endgame")
	DialogueManager.area_final = false
	DialogueManager.on_area = false

func _on_button_pressed():
	Transicao.transicionar("res://scenes/inicio.tscn")
