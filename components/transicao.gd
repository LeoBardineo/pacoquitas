extends CanvasLayer

@onready var fundo = $FundoPreto

var player_pos

func _ready():
	fundo.visible = false
	fundo.modulate.a = 0.0

func transicionar(scene_path: String, group : String = ""):
	if(scene_path == null || scene_path == ""):
		printerr("cena null")
		return
	fundo.visible = true
	var fade_out = create_tween()
	fade_out.tween_property(fundo, "modulate:a", 1.0, 0.5)
	await fade_out.finished
	DialogueManager.clear_char_map()
	
	get_tree().change_scene_to_file(scene_path)
	await get_tree().create_timer(0.2).timeout
	
	if(group != ""):
		var player_pos : Marker2D = get_tree().get_first_node_in_group(group)
		if(player_pos != null):
			var benicio : CharacterBody2D = DialogueManager.char_node_map['Benicio']['node']
			benicio.position = player_pos.position
	var fade_in = create_tween()
	fade_in.tween_property(fundo, "modulate:a", 0.0, 0.5)
	await fade_in.finished
	fundo.visible = false
	

func transicionar_com_dialogo(scene_path: String, story_path : String, group : String = ""):
	await transicionar(scene_path, group)
	var ink_story_lena : InkStory = load(story_path) as InkStory
	DialogueManager.iniciar(ink_story_lena, false, "questlena_concluida")
