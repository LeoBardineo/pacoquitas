extends Control

@onready var fundo = $Control/Fundo
@onready var alvo = $Control/Alvo
@onready var ponteiro = $Control/Ponteiro

@onready var min_alvo_pos = fundo.size.x / 4.0
@onready var max_alvo_pos = fundo.size.x - alvo.size.x
@onready var max_ponteiro_pos = fundo.size.x - ponteiro.size.x

@export var velocidade : float = 400.0

var parou_barrinha: bool = false

signal minigame_venceu
signal minigame_perdeu

func _ready():
	iniciar_jogo()

func iniciar_jogo():
	ponteiro.position.x = fundo.position.x
	alvo.position.x = randf_range(min_alvo_pos, max_alvo_pos)
	

func _process(delta):
	if parou_barrinha: return
	ponteiro.position.x += velocidade * delta
	if(ponteiro.position.x >= max_ponteiro_pos):
		print('perdeu')
		piscar_ponteiro()
		falhar()
		minigame_perdeu.emit()

func _unhandled_input(event):
	if parou_barrinha: return
	if(event.is_action_pressed("interaction")):
		parou_barrinha = true
		get_viewport().set_input_as_handled()
		verificar_acerto()

func verificar_acerto():
	var centro_ponteiro = ponteiro.position.x + (ponteiro.size.x / 2.0)
	var inicio_alvo = alvo.position.x
	var fim_alvo = alvo.position.x + alvo.size.x
	if centro_ponteiro >= inicio_alvo && centro_ponteiro <= fim_alvo:
		print('acertou')
		ganhar()
	else:
		print('errou')
		falhar()
		await piscar_ponteiro()
		minigame_perdeu.emit()
	

func ganhar():
	ponteiro.color = Color.GREEN
	minigame_venceu.emit()

func falhar():
	parou_barrinha = true
	ponteiro.color = Color.RED

func piscar_ponteiro():
	var tween = create_tween()
	tween.set_loops(3)
	tween.tween_property(ponteiro, "modulate:a", 0.0, 0.15)
	tween.tween_property(ponteiro, "modulate:a", 1, 0.15)
	await tween.finished
