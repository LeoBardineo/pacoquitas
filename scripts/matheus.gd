extends Node2D

@export var on_sala : bool = false

func _ready():
	if(on_sala && GameManager.quests["Enzo"]["concluida"]):
		get_parent().queue_free()
		return
	visible = GameManager.quests["Enzo"]["concluida"]
	if(!visible):
		queue_free()
