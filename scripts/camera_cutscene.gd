extends Node2D

@onready var camera = $CameraCutscene
@onready var animation_player = $CameraCutscene/AnimationPlayer

func _ready():
	await get_tree().create_timer(2.0).timeout 
	animation_player.play("cutscene_01")
