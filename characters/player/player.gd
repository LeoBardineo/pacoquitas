extends CharacterBody2D

const SPEED: float = 250.0
var direction: Vector2 = Vector2(1, 1)

func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	
	if(velocity.y > 0):
		$AnimatedSprite2D.play("vo_down")
	elif(velocity.y < 0):
		$AnimatedSprite2D.play("vo_up")
	
	if(velocity.x > 0):
		$AnimatedSprite2D.flip_h = 1
	elif(velocity.x < 0):
		$AnimatedSprite2D.flip_h = 0
	
	move_and_slide()
	
