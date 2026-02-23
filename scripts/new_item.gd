extends Control

@onready var fundo_blur = $ColorRect
@onready var centro = $CenterContainer
@onready var item_imagem = $CenterContainer/VBoxContainer/TextureRect
@onready var item_texto = $CenterContainer/VBoxContainer/RichTextLabel

func _ready():
	visible = false

func mostrar_item(textura_do_item: Texture2D, nome_do_item: String):
	item_imagem.texture = textura_do_item
	item_texto.text = "Você encontrou: " + nome_do_item

	fundo_blur.modulate.a = 0.0
	centro.modulate.a = 0.0
	visible = true

	var tween = create_tween().set_parallel(true)
	tween.tween_property(fundo_blur, "modulate:a", 1.0, 0.5)
	tween.tween_property(centro, "modulate:a", 1.0, 0.5)
	await tween.finished

	await get_tree().create_timer(3).timeout

	tween = create_tween().set_parallel(true)
	tween.tween_property(fundo_blur, "modulate:a", 0.0, 0.3)
	tween.tween_property(centro, "modulate:a", 0.0, 0.3)

	await tween.finished
	visible = false
	queue_free()
