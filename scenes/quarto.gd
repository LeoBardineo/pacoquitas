extends Node2D

func _ready():
	var quests = GameManager.quests
	if(!quests["Enzo"]["concluida"] && quests["Matheus"]["concluida"]):
		quests["Enzo"]["concluida"] = true
		Transicao.transicionar("res://scenes/quarto_cutscene.tscn")
	
