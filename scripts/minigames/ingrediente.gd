extends Sprite2D

@onready var manager : Node2D = get_parent().get_parent()
@onready var area : Area2D = get_node("Area2D")

@export var som_ingrediente : AudioStream

var mouse_em_cima : bool = false

func _ready():
	area.input_event.connect(_on_input_event)
	area.mouse_entered.connect(_on_mouse_entered)
	area.mouse_exited.connect(_on_mouse_exited)

func _on_input_event(viewport : Node, event : InputEvent, shape_idx : int):
	if !(event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed): return
	if (!mouse_em_cima): return
	print("clicou ingrediente de nome " + name)
	manager.colocar_ingrediente_na_mesa()
	var ingredientes_mesa : Node2D = manager.ingredientes_mesa
	var ingrediente_na_mesa : Node2D = ingredientes_mesa.find_child(name)
	visible = false
	ingrediente_na_mesa.visible = true
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
