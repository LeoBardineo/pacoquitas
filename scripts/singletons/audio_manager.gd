extends Node

@onready var music_player = $MusicPlayer

var streams_tocando : Array[AudioStream] = []

func tocar_musica(musica : AudioStream, loop : bool = true):
	if(music_player.stream == musica && music_player.playing): return
	musica.loop = loop
	music_player.stream = musica
	music_player.play()

func parar_musica():
	music_player.stop()

func tocar_sfx(sfx : AudioStream, pos : Vector2):
	if(streams_tocando.has(sfx)): return
	var sfx_player = AudioStreamPlayer2D.new()
	sfx_player.stream = sfx
	sfx_player.bus = "SFX"
	sfx_player.global_position = pos
	add_child(sfx_player)
	sfx_player.play()
	streams_tocando.append(sfx)
	sfx_player.finished.connect(fim_de_sfx)

func fim_de_sfx(sfx_player : AudioStreamPlayer2D):
	sfx_player.queue_free()
	streams_tocando.erase(sfx_player.stream)
