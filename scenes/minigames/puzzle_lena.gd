extends Node2D

func _unhandled_input(event):
	if(event.is_action_pressed("interaction")):
		GameManager.quests["Lena"]["concluida"] = true
		await Transicao.transicionar_com_dialogo("res://scenes/cozinha.tscn", "res://ink/final/Vó Lena.ink", "questlena_concluida", "PuzzleLena")
