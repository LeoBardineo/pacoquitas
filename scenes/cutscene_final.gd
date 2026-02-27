extends Node2D

func _ready():
	var anim : AnimationPlayer = $CameraCutscene/AnimationPlayer
	anim.animation_finished.connect(_on_anim_finish)

func _on_anim_finish(_e):
	var ink_story = load("res://ink/final/Dandara.ink") as InkStory
	DialogueManager.iniciar(ink_story, true, "finale_1")
	DialogueManager.on_area = true
	await DialogueManager.dialogo_terminou
	Transicao.transicionar_com_dialogo("res://scenes/escritorio_cutscene.tscn", "res://ink/final/Dandara.ink", "finale_2")
