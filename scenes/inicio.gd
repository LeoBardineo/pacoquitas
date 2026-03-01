extends CanvasLayer

@onready var ui_1 = load('res://assets/audio/ui 1.wav')
@onready var ui_2 = load('res://assets/audio/ui 2.wav')

func _on_jogar_button_pressed():
	if(ui_2 != null):
		AudioManager.tocar_unico(ui_2)
	Transicao.transicionar("res://scenes/sala_de_estar_cutscene_1.tscn")

func _on_opcoes_button_pressed():
	PauseMenu.pause()

func _on_sair_button_pressed():
	get_tree().quit()

func _on_jogar_button_mouse_entered():
	if(ui_1 != null):
		AudioManager.tocar_unico(ui_1)
