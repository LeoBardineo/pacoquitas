extends Node

@onready var music_player = $MusicPlayer

var streams_tocando : Dictionary = {}

func tocar_musica(musica : AudioStream, loop : bool = true):
	if(music_player.stream == musica && music_player.playing): return
	musica.loop = loop
	music_player.stream = musica
	music_player.play()

func parar_musica():
	music_player.stop()

func tocar_sfx(sfx : AudioStream):
	if(streams_tocando.has(sfx) and is_instance_valid(streams_tocando[sfx])):
		if(streams_tocando[sfx].playing):
			return
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = sfx
	sfx_player.bus = "SFX"
	add_child(sfx_player)
	streams_tocando[sfx] = sfx_player
	sfx_player.play()
	sfx_player.finished.connect(fim_de_sfx.bind(sfx, sfx_player))

func pause_sfx(sfx : AudioStream):
	if(!streams_tocando.has(sfx) or !is_instance_valid(streams_tocando[sfx])):
		return
	var sfx_player = streams_tocando[sfx]
	sfx_player.stop()
	sfx_player.queue_free()
	streams_tocando.erase(sfx)

func fim_de_sfx(sfx : AudioStream, sfx_player : AudioStreamPlayer):
	if streams_tocando.has(sfx) and streams_tocando[sfx] == sfx_player:
		streams_tocando.erase(sfx)
	sfx_player.queue_free()
