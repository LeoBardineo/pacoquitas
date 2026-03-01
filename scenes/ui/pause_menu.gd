extends CanvasLayer

@onready var fundo = $Fundo
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

@onready var new_item_scene : PackedScene = preload("res://components/NewItem.tscn")
@onready var carimbo_texture : Texture2D = load("res://ui/puzzle walter/CARIMBO MINIGAME COZINHA.png") as Texture2D

signal fim_item_obtido

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
	fundo.visible = pausado
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

func item_obtido(item_spr : Texture2D, item_name : String):
	var dialog_on_area = DialogueManager.on_area
	DialogueManager.on_area = false
	fundo.visible = false
	botoes_principais.visible = false
	visible = true
	var new_item = new_item_scene.instantiate()
	add_child(new_item)
	await new_item.mostrar_item(item_spr, item_name)
	new_item.queue_free()
	visible = false
	DialogueManager.on_area = dialog_on_area
	fim_item_obtido.emit()

func ganhou_carimbo(carimbo_name : String = "Carimbo"):
	var player_em_cena = DialogueManager.char_node_map.has("Benicio")
	var animacao_before = null
	var benicio_spr : AnimatedSprite2D = null
	if(player_em_cena):
		var benicio : CharacterBody2D = DialogueManager.char_node_map['Benicio']['node']
		benicio_spr = benicio.get_node("AnimatedSprite2D")
		animacao_before = benicio_spr.animation
		print("animacao_before : " + animacao_before)
		benicio_spr.play("player_ganhou_carimbo")
	await item_obtido(carimbo_texture, carimbo_name)
	if(player_em_cena):
		benicio_spr.play(animacao_before)
