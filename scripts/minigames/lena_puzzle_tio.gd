extends CharacterBody2D

@export var nome : String
@export var dialogue_bg_color : Color
@export var outline_color : Color
@export var perdeu_dialogue : InkStory

@onready var sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")

func _ready():
	if (perdeu_dialogue == null):
		printerr("SEM PERDEU DIALOGUE NA LENA NO PUZZLE DO TIO")
	var dict = {
		"node": self,
		"dialogue_bg_color": dialogue_bg_color,
		"outline_color": outline_color
	}
	DialogueManager.insert_char(nome, dict)
	

func perdeu_effect():
	print('perdeu effect')
	await get_tree().create_timer(1).timeout
	sprite.play("vo_irritada")
	await get_tree().create_timer(0.5).timeout
	DialogueManager.on_area = true
	DialogueManager.iniciar(perdeu_dialogue)
	await DialogueManager.dialogo_terminou
	DialogueManager.on_area = false
	DialogueManager.interagindo = true
	await get_tree().create_timer(1).timeout
	sprite.play("vo_up")
	await get_tree().create_timer(0.5).timeout
	DialogueManager.interagindo = false
	DialogueManager.resetar_story()
	print('voltouuu')
	pass
