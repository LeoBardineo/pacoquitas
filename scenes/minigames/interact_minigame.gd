extends Area2D

@onready var outline_shader : ShaderMaterial = preload("res://materials/outline_shader_material.tres")
@onready var barrinha_cena : PackedScene = preload("res://components/minigames/barrinha.tscn")

@export var outline_color : Color = Color.BLUE_VIOLET
@export var canvas_layer : CanvasLayer
@export var personagem : CharacterBody2D
@export var sprite_interagivel : Sprite2D

@export var item_spr : Texture2D = preload("res://ui/puzzle walter/bigcerveja.png")
@export var item_name : String = "Cerveja do Tio Walter"

var barrinha : Control
var on_area : bool = false
var ganhou : bool = false
var jogando : bool = false

func _on_body_entered(body):
	if ganhou: return
	if(body.is_in_group("Player")):
		print('player entrou na area')
		outline(true)
		on_area = true

func _on_body_exited(body):
	if ganhou: return
	if(body.is_in_group("Player")):
		print('player saiu da area')
		outline(false)
		on_area = false

func _unhandled_input(event):
	if !on_area || DialogueManager.interagindo || ganhou || jogando: return
	if(event.is_action_pressed("interaction")):
		print('interagiu')
		iniciar_minigame()

func iniciar_minigame():
	jogando = true
	barrinha = barrinha_cena.instantiate()
	canvas_layer.add_child(barrinha)
	barrinha.minigame_venceu.connect(venceu_effect)
	barrinha.minigame_perdeu.connect(perdeu_effect)
	DialogueManager.interagindo = true
	DialogueManager.char_node_map['Benicio']['node'].play_idle_animation()
	pass

func venceu_effect():
	ganhou = true
	outline(false)
	on_area = false
	DialogueManager.interagindo = false
	canvas_layer.remove_child(barrinha)
	PauseMenu.fim_item_obtido.connect(_on_fim_item_obtido)
	PauseMenu.item_obtido(item_spr, item_name)
	pass

func _on_fim_item_obtido():
	GameManager.quests["Walter"]["concluida"] = true
	DialogueManager.dar_carimbo = true
	await Transicao.transicionar_com_dialogo("res://scenes/jardim.tscn", "res://ink/final/Walter.ink", "questwalter_concluida", "PuzzleWalter")

func perdeu_effect():
	canvas_layer.remove_child(barrinha)
	await personagem.perdeu_effect()
	jogando = false
	pass

func outline(b: bool):
	sprite_interagivel.material = outline_shader if b else null
	if b && outline_color != null:
		sprite_interagivel.material.set_shader_parameter("color", outline_color)
