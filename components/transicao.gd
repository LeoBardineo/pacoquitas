extends CanvasLayer

@onready var fundo = $FundoPreto

func _ready():
	fundo.visible = false
	fundo.modulate.a = 0.0

func transicionar(scene: PackedScene):
	fundo.visible = true
	var fade_out = create_tween()
	fade_out.tween_property(fundo, "modulate:a", 1.0, 0.5)
	await fade_out.finished
	
	get_tree().change_scene_to_packed(scene)
	await get_tree().create_timer(0.2).timeout
	
	var fade_in = create_tween()
	fade_in.tween_property(fundo, "modulate:a", 0.0, 0.5)
	await fade_in.finished
	fundo.visible = false
	
