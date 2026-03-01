extends Sprite2D

@onready var manager : Node2D = get_parent().get_parent()
@onready var area : Area2D = get_node("Area2D")
@onready var carimbo_sound = load("res://assets/audio/carimbo.wav") as AudioStream

@export var carimbo_spr : Texture2D

var pos_inicial : Vector2
var mouse_em_cima : bool = false
var sendo_segurado : bool = false
var carimbado : bool = false
var area_livro : Area2D

signal carimbada_ocorreu

func _ready():
	pos_inicial = global_position
	area.input_event.connect(_on_input_event)
	area.mouse_entered.connect(_on_mouse_entered)
	area.mouse_exited.connect(_on_mouse_exited)
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)

func _on_area_entered(outra_area: Area2D):
	area_livro = outra_area
	print(area_livro.get_groups())

func _on_area_exited(outra_area: Area2D):
	area_livro = null
	print("sem area")

func _on_input_event(viewport : Node, event : InputEvent, shape_idx : int):
	if !(event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed): return
	if (manager.segurando || !mouse_em_cima): return
	print("prendeu carimbo")
	manager.segurando = true
	sendo_segurado = true
	get_viewport().set_input_as_handled()
	pass

func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	mouse_em_cima = true
	print("mouse em cima")

func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	mouse_em_cima = false
	print("mouse não em cima")

func _process(delta):
	if !(sendo_segurado): return
	global_position = get_global_mouse_position()

func _unhandled_input(event):
	if !(sendo_segurado): return
	if !(event is InputEventMouseButton && event.pressed): return
	if (event.button_index == MOUSE_BUTTON_LEFT):
		if(area_livro != null):
			print(area_livro.get_groups())
			if area_livro.is_in_group("Livro"):
				var carimbada = Sprite2D.new()
				carimbada.texture = carimbo_spr
				carimbada.global_position = get_global_mouse_position()
				manager.add_child(carimbada)
				carimbada_ocorreu.emit(carimbado)
				carimbado = true
				AudioManager.tocar_sfx(carimbo_sound)
			if area_livro.is_in_group("PosInicial"):
				manager.segurando = false
				global_position = pos_inicial
				sendo_segurado = false
		get_viewport().set_input_as_handled()
	elif (event.button_index == MOUSE_BUTTON_RIGHT):
		print("voltou")
		manager.segurando = false
		global_position = pos_inicial
		sendo_segurado = false
		get_viewport().set_input_as_handled()
