extends Area2D

@export_file("*.tscn") var cena : String
@export var group_destino : String

@export var nome_quest_concluida : String
@export var nome_quest_nao_concluida : String
@export_file("*.tscn") var cena_cutscene : String

func _ready():
	body_entered.connect(transicionar)

func transicionar(body):
	if(body.is_in_group("Player")):
		var quests = GameManager.quests
		var concluida : bool = false
		var n_concluida : bool = false
		if(!nome_quest_concluida.is_empty()):
			concluida = quests[nome_quest_concluida]["concluida"]
		if(!nome_quest_nao_concluida.is_empty()):
			n_concluida = quests[nome_quest_nao_concluida]["concluida"]
		if(concluida && !n_concluida):
			Transicao.transicionar(cena_cutscene)
			return
		print('transicionou para ' + group_destino)
		Transicao.transicionar(cena, group_destino)
