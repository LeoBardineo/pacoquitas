extends CharacterBody2D

const SPEED: float = 250.0
var direction: Vector2 = Vector2(1, 1)
var last_direction = 'down'

func _physics_process(_delta: float) -> void:
	movimentacao()
	

func movimentacao():
	if DialogueManager.interagindo: return
	
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	
	if(velocity.y > 0):
		$AnimatedSprite2D.play("player_down")
		last_direction = 'down'
	elif(velocity.y < 0):
		# $AnimatedSprite2D.play("player_up")
		last_direction = 'up'
	
	if(velocity.x > 0):
		# $AnimatedSprite2D.play("player_left")
		last_direction = 'right'
	elif(velocity.x < 0):
		$AnimatedSprite2D.play("player_left")
		# $AnimatedSprite2D.flip_h = 1
		last_direction = 'left'
	elif(velocity.y == 0 && velocity.x == 0):
		if(last_direction != 'right' && last_direction != 'up'):
			$AnimatedSprite2D.play('player_idle_'+last_direction)
	
	move_and_slide()
	
