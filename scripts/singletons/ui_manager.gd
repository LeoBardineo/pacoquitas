extends CanvasLayer

@onready var new_item_scene : PackedScene = preload("res://components/NewItem.tscn")

signal fim_item_obtido

func item_obtido(canvas_layer : CanvasLayer, item_spr : Texture2D, item_name : String):
	var new_item = new_item_scene.instantiate()
	canvas_layer.add_child(new_item)
	await new_item.mostrar_item(item_spr, item_name)
	fim_item_obtido.emit()
