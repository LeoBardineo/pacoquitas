extends Node2D

@onready var camera : Camera2D = $CameraCutscene
@onready var animation_player : AnimationPlayer = $CameraCutscene/AnimationPlayer

@export var cutscene_id : int
@export_file("*.tscn") var next_scene : String
@export var dialogo_cutscene : InkStory
@export var personagens : Dictionary

var cutscenes : Array[Callable] = [
	introducao_1,
	introducao_2,
	quarto_enzo_matheus
]

func _ready():
	cutscenes[cutscene_id].call()

func dialogo():
	DialogueManager.iniciar(dialogo_cutscene, false, "")
	DialogueManager.on_area = true
	await DialogueManager.dialogo_terminou
	DialogueManager.on_area = false

func introducao_1():
	var benicio : AnimatedSprite2D = get_node(personagens["Benicio"])
	var pacoca : AnimatedSprite2D = get_node(personagens["Pacoca"])
	
	await get_tree().create_timer(2.0).timeout 
	animation_player.play("cutscene_01")
	await animation_player.animation_finished
	await dialogo()
	animation_player.play_backwards("cutscene_01")
	await animation_player.animation_finished
	benicio.play("player_sentado_carinho")
	await benicio.animation_finished
	benicio.play("player_sentado_carinho_carimbo")
	pacoca.play("carimbo")
	await benicio.animation_finished
	await get_tree().create_timer(2.0).timeout
	Transicao.transicionar(next_scene, "")
	pass

func introducao_2():
	var dandara : AnimatedSprite2D = get_node(personagens["Dandara"])
	var dandara_anim : AnimationPlayer = dandara.get_node("AnimationPlayer")
	
	await get_tree().create_timer(2.0).timeout 
	dandara.play("andar")
	dandara_anim.play("andar_1")
	await dandara_anim.animation_finished
	dandara.pause()
	await dialogo()
	dandara_anim.play_backwards("andar_1")
	dandara.play("andar")
	await dandara_anim.animation_finished
	await get_tree().create_timer(2.0).timeout
	Transicao.transicionar(next_scene, "")
	pass

func quarto_enzo_matheus():	
	dialogo_cutscene = load("res://ink/final/Enzo Gabriel.ink") as InkStory
	animation_player.play("quarto_benicio_andando")
	await animation_player.animation_finished
	
	DialogueManager.iniciar(dialogo_cutscene, true, "questmatheus_1")
	DialogueManager.on_area = true
	await DialogueManager.dialogo_terminou
	DialogueManager.on_area = false
	
	animation_player.play("camera_zoom_out")
	await animation_player.animation_finished
	
	DialogueManager.iniciar(dialogo_cutscene, true, "questmatheus_2")
	DialogueManager.on_area = true
	await DialogueManager.dialogo_terminou
	
	Transicao.transicionar(next_scene)
	
	pass
