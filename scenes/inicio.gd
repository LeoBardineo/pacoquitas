extends CanvasLayer

func _on_jogar_button_pressed():
	Transicao.transicionar("res://scenes/sala_de_estar_cutscene_1.tscn")

func _on_opcoes_button_pressed():
	PauseMenu.pause()

func _on_sair_button_pressed():
	get_tree().quit()
