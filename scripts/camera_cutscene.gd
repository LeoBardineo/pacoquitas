extends Node2D

@onready var camera = $CameraCutscene
@onready var animation_player = $CameraCutscene/AnimationPlayer

@export var cutscene_id : int
@export var next_scene : PackedScene
@export var dialogo_cutscene : InkStory
@export var personagens : Dictionary

var cutscenes : Array[Callable] = [
	introducao_1,
	introducao_2
]

func _ready():
	cutscenes[cutscene_id].call()

func dialogo():
	DialogueManager.iniciar(dialogo_cutscene)
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
	Transicao.transicionar(next_scene)
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
	Transicao.transicionar(next_scene)
	pass
