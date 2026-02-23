extends CanvasLayer

@onready var botoes_principais = $CenterContainer/OpcoesPrincipais

@onready var botoes_audio = $CenterContainer/OpcoesAudio
@onready var slider_geral = $CenterContainer/OpcoesAudio/GeralSlider
@onready var slider_music = $CenterContainer/OpcoesAudio/MusicaSlider
@onready var slider_sfx = $CenterContainer/OpcoesAudio/SFXSlider

@onready var master_bus = AudioServer.get_bus_index("Master")
@onready var music_bus = AudioServer.get_bus_index("Music")
@onready var sfx_bux = AudioServer.get_bus_index("SFX")

func _ready():
	visible = false
	botoes_audio.visible = false
	slider_geral.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	slider_music.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	slider_sfx.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bux))

func _unhandled_input(event):
	if(event.is_action_pressed("ui_cancel")):
		pause()
		get_viewport().set_input_as_handled()
	

func pause():
	var pausado = !get_tree().paused
	get_tree().paused = pausado
	visible = pausado
	botoes_principais.visible = true
	botoes_audio.visible = false

func _on_continuar_pressed():
	pause()

func _on_audio_pressed():
	botoes_principais.visible = false
	botoes_audio.visible = true

func _on_graficos_pressed():
	pass # Replace with function body.

func _on_sair_pressed():
	get_tree().quit()

func _on_voltar_pressed():
	botoes_principais.visible = true
	botoes_audio.visible = false

func _on_geral_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))

func _on_musica_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bux, linear_to_db(value))
