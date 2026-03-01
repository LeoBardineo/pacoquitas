extends CanvasLayer

@onready var fundo = $FundoPreto

var player_pos
var transicionando : bool = false

func _ready():
	fundo.visible = false
	fundo.modulate.a = 0.0

func transicionar(scene_path: String, group : String = ""):
	if(transicionando): return
	if(scene_path == null || scene_path == ""):
		printerr("cena null")
		return
	var dialog_on_area = DialogueManager.on_area
	DialogueManager.on_area = false
	transicionando = true
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
	transicionando = false
	DialogueManager.on_area = dialog_on_area
	

func transicionar_com_dialogo(scene_path: String, story_path : String, knot : String,
	group : String = ""):
	await transicionar(scene_path, group)
	var ink_story : InkStory = load(story_path) as InkStory
	DialogueManager.on_area = true
	DialogueManager.iniciar(ink_story, false, knot)
