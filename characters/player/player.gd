extends CharacterBody2D

const SPEED: float = 250.0
var direction: Vector2 = Vector2(1, 1)

func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	move_and_slide()
	
