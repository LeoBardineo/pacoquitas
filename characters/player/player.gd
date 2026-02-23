extends CharacterBody2D

@export var nome : String
@export var bg_color : Color
@export var speed: float = 250.0

@onready var outline_shader : ShaderMaterial = preload("res://materials/outline_shader_material.tres")

var direction: Vector2 = Vector2(1, 1)
var last_direction = 'down'
var near_interactables : Array[CharacterBody2D] = []
var nearest_interactable : CharacterBody2D = null

func _ready():
	var dict = {
		"node": self,
		"bg_color": bg_color
	}
	DialogueManager.insert_char(nome, dict)

func _process(_delta):
	update_interaction_icon()

func update_interaction_icon():
	if near_interactables.size() <= 1 || velocity.is_zero_approx(): return
	var lowest_distance = INF
	var interactable = null
	for i in near_interactables:
		outline(i, false)
		var distance = global_position.distance_squared_to(i.global_position)
		if distance < lowest_distance:
			lowest_distance = distance
			interactable = i
	nearest_interactable = interactable
	if(nearest_interactable != null && !DialogueManager.interagindo):
		print(nearest_interactable)
		outline(nearest_interactable, true)
	pass

func insert_interactable(interactable: CharacterBody2D):
	near_interactables.append(interactable)
	DialogueManager.on_area = true
	if(near_interactables.size() == 1):
		outline(interactable, true)
		nearest_interactable = interactable

func remove_interactable(interactable: CharacterBody2D):
	near_interactables.erase(interactable)
	if(near_interactables.is_empty()):
		outline(interactable, false)
		nearest_interactable = null
		DialogueManager.on_area = false

func outline(interactable: CharacterBody2D, b: bool):
	var sprite : AnimatedSprite2D = interactable.get_node("AnimatedSprite2D")
	sprite.material = outline_shader if b else null
	if b && interactable.outline_color != null:
		sprite.material.set_shader_parameter("color", interactable.outline_color)

func _unhandled_input(event):
	if(DialogueManager.interagindo or nearest_interactable == null): return
	if event.is_action_released("interaction"):
		print('tentando começar')
		DialogueManager.iniciar(nearest_interactable.story)
		outline(nearest_interactable, false)
		

func _physics_process(_delta: float) -> void:
	movimentacao()
	

func movimentacao():
	if DialogueManager.interagindo: return
	
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	if(velocity.y > 0):
		$AnimatedSprite2D.play("player_down")
		last_direction = 'down'
	elif(velocity.y < 0):
		$AnimatedSprite2D.play("player_up")
		last_direction = 'up'
	elif(velocity.x > 0):
		$AnimatedSprite2D.play("player_right")
		last_direction = 'right'
	elif(velocity.x < 0):
		$AnimatedSprite2D.play("player_left")
		last_direction = 'left'
	elif(velocity.y == 0 && velocity.x == 0):
		play_idle_animation()
	
	move_and_slide()

func play_idle_animation():
	$AnimatedSprite2D.play('player_idle_'+last_direction)
