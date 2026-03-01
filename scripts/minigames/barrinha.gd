extends Control

@onready var fundo = $Control/Fundo
@onready var alvo = $Control/Alvo
@onready var ponteiro = $Control/Ponteiro

@onready var min_alvo_pos = fundo.size.x / 4.0
@onready var max_alvo_pos = fundo.size.x - alvo.size.x
@onready var max_ponteiro_pos = fundo.size.x - ponteiro.size.x
@onready var ponteiro_y = ponteiro.position.y

@export var velocidade : float = 400.0
@export var acertou_barra_sound : AudioStream
@export var errou_barra_sound : AudioStream

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
		var tween = create_tween()
		descer_ponteiro(tween)
		subir_ponteiro(tween)
		await tween.finished
		minigame_perdeu.emit()
	

func ganhar():
	AudioManager.tocar_sfx(acertou_barra_sound)
	var tween = create_tween()
	descer_ponteiro(tween)
	await tween.finished
	minigame_venceu.emit()

func falhar():
	parou_barrinha = true
	AudioManager.tocar_sfx(errou_barra_sound)

func descer_ponteiro(tween):
	tween.tween_property(ponteiro, "position:y", ponteiro_y + 100, 1.0)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_SINE)

func subir_ponteiro(tween):
	tween.tween_property(ponteiro, "position:y", ponteiro_y, 1.0)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_SINE)

func piscar_ponteiro():
	var tween = create_tween()
	tween.set_loops(3)
	tween.tween_property(ponteiro, "modulate:a", 0.0, 0.15)
	tween.tween_property(ponteiro, "modulate:a", 1, 0.15)
	await tween.finished
