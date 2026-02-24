extends Area2D

@export_file("*.tscn") var cena : String

func _ready():
	body_entered.connect(transicionar)

func transicionar(body):
	if(body.is_in_group("Player")):
		Transicao.transicionar(cena)
