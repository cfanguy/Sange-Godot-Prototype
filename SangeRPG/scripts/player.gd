extends CharacterBody2D

const speed = 500
var last_direction = Vector2.ZERO
var animated_sprite
var enemy_in_range = false

func _ready():
	animated_sprite = $AnimatedSprite2D
	add_to_group("Player")

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right",
		"ui_up", "ui_down").normalized()
	velocity = direction * speed
	
	if direction != Vector2.ZERO:
		last_direction = direction
		
	if direction.x != 0:
		animated_sprite.play("walk_left")
	elif direction.y < 0:
		animated_sprite.play("walk_up")
	elif direction.y > 0:
		animated_sprite.play("walk_down")
	else:
		if last_direction.x != 0:
			animated_sprite.play("idle_left")
		elif last_direction.y < 0:
			animated_sprite.play("idle_up")
		elif last_direction.y > 0:
			animated_sprite.play("idle_down")
	
	animated_sprite.flip_h = last_direction.x > 0

	move_and_slide()


func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemy"):
		enemy_in_range = true
		print("Being Attacked!")


func _on_hitbox_body_exited(body):
	if body.is_in_group("Enemy"):
		enemy_in_range = false
		print("Enemy left hibox!")
