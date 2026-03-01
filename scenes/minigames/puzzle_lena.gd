extends Node2D

@onready var ingredientes = $Ingredientes
@onready var ingredientes_mesa = $IngredientesNaMesa

var count_ingredientes : int = 0

func colocar_ingrediente_na_mesa():
	count_ingredientes += 1
	print(str(count_ingredientes) + " de " + str(ingredientes.get_child_count()))
	if(count_ingredientes == ingredientes.get_child_count()):
		concluido()

func concluido():
	GameManager.quests["Lena"]["concluida"] = true
	DialogueManager.dar_carimbo = true
	await Transicao.transicionar_com_dialogo("res://scenes/cozinha.tscn", "res://ink/final/Vó Lena.ink", "questlena_concluida", "PuzzleLena")
