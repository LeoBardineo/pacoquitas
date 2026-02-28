extends Node2D

var segurando : bool = false
var quantidade_carimbadas : int = 0

func _ready():
	var carimbos = $Carimbos.get_children()
	for carimbo in carimbos:
		carimbo.carimbada_ocorreu.connect(_on_carimbada_ocorreu)
	

func _on_carimbada_ocorreu(carimbado):
	if(!carimbado):
		quantidade_carimbadas += 1
	if(quantidade_carimbadas >= 7):
		await get_tree().create_timer(1.0).timeout 
		Transicao.transicionar("res://scenes/endgame.tscn")
