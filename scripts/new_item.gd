extends Control

@onready var fundo_blur = $ColorRect
@onready var centro = $CenterContainer
@onready var item_imagem = $CenterContainer/VBoxContainer/TextureRect
@onready var item_texto = $CenterContainer/VBoxContainer/RichTextLabel

func _ready():
	visible = false

func mostrar_item(textura_do_item: Texture2D, nome_do_item: String):
	item_imagem.texture = textura_do_item
	item_texto.text = "Você encontrou: \n" + nome_do_item

	fundo_blur.modulate.a = 0.0
	centro.modulate.a = 0.0
	visible = true

	var interagindo = DialogueManager.interagindo
	DialogueManager.interagindo = true
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(fundo_blur, "material:shader_parameter/blur_force", 2.5, 1)
	tween.tween_property(fundo_blur, "modulate:a", 1.0, 1)
	await tween.finished
	
	tween = create_tween().set_parallel(true)
	tween.tween_property(centro, "modulate:a", 1.0, 1)
	await tween.finished

	await get_tree().create_timer(2.5).timeout

	tween = create_tween().set_parallel(true)
	tween.tween_property(centro, "modulate:a", 0.0, 1)
	await tween.finished
	
	tween = create_tween().set_parallel(true)
	tween.tween_property(fundo_blur, "material:shader_parameter/blur_force", 0, 1)
	tween.tween_property(fundo_blur, "modulate:a", 0.0, 1)
	await tween.finished
	
	DialogueManager.interagindo = interagindo
	visible = false
	queue_free()
