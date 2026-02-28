extends Node2D

var quests = {
	"Lena": {"color": Color("ffa694"), "knot": knot_lena, "concluida": false},
	"Walter": {"color": Color("e9cca4"), "knot": knot_walter, "concluida": false, "solicitou_quest": false},
	"Iracema": {"color": Color("fcc0da"), "knot": knot_iracema, "concluida": false},
	"Enzo": {"color": Color("60c4dc"), "knot": knot_enzo, "concluida": false, "solicitou_quest": false},
	"Matheus": {"color": Color("caa749"), "knot": knot_matheus, "concluida": false},
	"Dandara": {"color": Color("70a1a6"), "knot": knot_dandara, "concluida": false},
}

var cursor_1 = load("res://ui/mouse/padrão.png")
var cursor_2 = load("res://ui/mouse/click.png")

func _ready():
	Input.set_custom_mouse_cursor(cursor_1)
	Input.set_custom_mouse_cursor(cursor_2, Input.CURSOR_POINTING_HAND)

func sprite_atual(nome : String):
	if(nome == "Walter"):
		if(quests["Walter"]["concluida"]):
			return "idle_cerveja"
		return "idle"
	return ""

func knot_atual(nome: String):
	var knot_call : Callable = quests[nome]["knot"]
	return knot_call.call()

func knot_lena():
	var lena_node = DialogueManager.char_node_map["Lena"]["node"]
	if(!quests["Lena"]["concluida"]):
		lena_node.go_to_scene = true
		lena_node.scene = "res://scenes/minigames/puzzle_lena.tscn"
		return "questlena"
	return "repeat"

func knot_walter():
	if(!quests["Lena"]["concluida"]): return "questlena"
	if(!quests["Walter"]["concluida"]):
		var walter_node = DialogueManager.char_node_map["Walter"]["node"]
		quests["Walter"]["solicitou_quest"] = true
		walter_node.go_to_scene = true
		walter_node.scene = "res://scenes/minigames/puzzle_walter.tscn"
		return "questwalter"
	return "repeat"

func knot_iracema():
	if(!quests["Lena"]["concluida"]): return "questlena"
	if(!quests["Walter"]["concluida"]): return "questwalter"
	if(!quests["Iracema"]["concluida"]):
		quests["Iracema"]["concluida"] = true
		return "questiracema"
	return "repeat"

func knot_matheus():
	if(!quests["Lena"]["concluida"]): return "repeat"
	if(!quests["Walter"]["concluida"]): return "repeat"
	if(!quests["Iracema"]["concluida"]): return "repeat"
	if(quests["Enzo"]["solicitou_quest"]):
		quests["Matheus"]["concluida"] = true
		return "questenzo"
	return "repeat"

func knot_enzo():
	if(!quests["Lena"]["concluida"]): return "repeat"
	if(!quests["Walter"]["concluida"]): return "repeat"
	if(!quests["Iracema"]["concluida"]): return "repeat"
	if(quests["Enzo"]["solicitou_quest"] && !quests["Matheus"]["concluida"]): return "repeat"
	if(!quests["Enzo"]["concluida"] && !quests["Matheus"]["concluida"]):
		quests["Enzo"]["solicitou_quest"] = true
		return "questenzo"
	if(!quests["Enzo"]["concluida"] && quests["Matheus"]["concluida"]):
		quests["Enzo"]["concluida"] = true
		return "questmatheus"
	return "repeat"

func knot_dandara():
	pass
