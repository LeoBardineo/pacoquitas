extends Area2D

@onready var outline_shader : ShaderMaterial = preload("res://materials/outline_shader_material.tres")
@onready var sprite_interagivel : Sprite2D = get_node("PortaFechada")

@export var outline_color : Color = Color.BLUE_VIOLET
@export_file("*.tscn") var cena : String
@export var group_destino : String

var on_area : bool = false

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
	if !on_area || DialogueManager.interagindo: return
	if(event.is_action_pressed("interaction")):
		print('interagiu')
		Transicao.transicionar(cena, group_destino)

func outline(b: bool):
	sprite_interagivel.material = outline_shader if b else null
	if b && outline_color != null:
		sprite_interagivel.material.set_shader_parameter("color", outline_color)
