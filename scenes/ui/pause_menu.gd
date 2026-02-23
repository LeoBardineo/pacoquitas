extends CanvasLayer

@onready var botoes_principais = $CenterContainer/OpcoesPrincipais

@onready var botoes_audio = $CenterContainer/OpcoesAudio
@onready var slider_geral = $CenterContainer/OpcoesAudio/GeralSlider
@onready var slider_music = $CenterContainer/OpcoesAudio/MusicaSlider
@onready var slider_sfx = $CenterContainer/OpcoesAudio/SFXSlider

@onready var botoes_grafico = $CenterContainer/OpcoesGrafico
@onready var botao_tela_cheia = $CenterContainer/OpcoesGrafico/TelaCheia
@onready var resolucoes_menu = $CenterContainer/OpcoesGrafico/ResolucoesMenu

@onready var master_bus = AudioServer.get_bus_index("Master")
@onready var music_bus = AudioServer.get_bus_index("Music")
@onready var sfx_bux = AudioServer.get_bus_index("SFX")

var resolucoes : Array[Vector2i] = [
	Vector2i(1920, 1080),
	Vector2i(1366, 768),
	Vector2i(1280, 720),
	Vector2i(960, 540)
]

func _ready():
	visible = false
	botoes_audio.visible = false
	botoes_grafico.visible = false
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
	botoes_principais.visible = false
	botoes_grafico.visible = true
	resolucoes_menu.clear()
	for resolucao in resolucoes:
		var x = resolucao[0]
		var y = resolucao[1]
		var res = str(x) + " x " + str(y)
		resolucoes_menu.add_item(res)

func _on_sair_pressed():
	get_tree().quit()

func _on_voltar_pressed():
	botoes_principais.visible = true
	botoes_audio.visible = false
	botoes_grafico.visible = false

func _on_geral_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))

func _on_musica_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bux, linear_to_db(value))

func _on_tela_cheia_toggled(toggled_on):
	var tela : DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(tela)
	resolucoes_menu.disabled = toggled_on

func _on_resolucoes_menu_item_selected(index):
	var resolucao = resolucoes[index]
	DisplayServer.window_set_size(resolucao)
	var tamanho_tela = DisplayServer.screen_get_size()
	var centro_da_tela = (tamanho_tela - resolucao) / 2
	DisplayServer.window_set_position(centro_da_tela)
