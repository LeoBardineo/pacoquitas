extends Area2D

@export_file("*.tscn") var cena : String
@export var group_destino : String

func _ready():
	body_entered.connect(transicionar)

func transicionar(body):
	if(body.is_in_group("Player")):
		print('transicionou para ' + group_destino)
		Transicao.transicionar(cena, group_destino)
