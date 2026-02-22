extends Area2D

@onready var outline_shader : ShaderMaterial = preload("res://materials/outline_shader_material.tres")
@onready var barrinha_cena : PackedScene = preload("res://components/minigames/barrinha.tscn")

@export var outline_color : Color = Color.BLUE_VIOLET

var barrinha : Control
var on_area : bool = false
var jogando : bool = false

func _on_body_entered(body):
	if(body.is_in_group("Player")):
		print('player entrou na area')
		outline(true)
		on_area = true

func _on_body_exited(body):
	if(body.is_in_group("Player")):
		print('player saiu da area')
		outline(false)
		on_area = false

func _unhandled_input(event):
	if !on_area || jogando: return
	if(event.is_action_pressed("interaction")):
		print('interagiu')
		iniciar_minigame()
		jogando = true
	

func iniciar_minigame():
	barrinha = barrinha_cena.instantiate()
	add_child(barrinha)
	barrinha.minigame_venceu.connect(venceu_effect)
	barrinha.minigame_perdeu.connect(perdeu_effect)
	DialogueManager.interagindo = true
	pass

func reset():
	DialogueManager.interagindo = false
	remove_child(barrinha)
	jogando = false

func venceu_effect():
	reset()
	pass

func perdeu_effect():
	reset()
	pass

func outline(b: bool):
	var sprite : Sprite2D = get_node("Geladeirafechada")
	sprite.material = outline_shader if b else null
	if b && outline_color != null:
		sprite.material.set_shader_parameter("color", outline_color)
