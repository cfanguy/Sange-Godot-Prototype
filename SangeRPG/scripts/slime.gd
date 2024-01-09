extends CharacterBody2D

var speed = 250
var attack_speed = 300
var last_direction = Vector2.ZERO
var animated_sprite
var direction_change_timer = 0
var direction_change_interval = 5
var attack = false
var player = null
var player_in_range = false

var min_position = Vector2(0, 0)
var max_position = Vector2(4000, 3000)

func _ready():
	animated_sprite = $AnimatedSprite2D
	pick_random_direction()
	add_to_group("Enemy")
	
func _physics_process(delta):
	if attack:
		var direction_to_player = (player.position - position).normalized()
		velocity = direction_to_player * attack_speed
		update_animation(direction_to_player, true)
	else:
		direction_change_timer += delta
		if direction_change_timer >= direction_change_interval:
			pick_random_direction()
			direction_change_timer = 0
	
		velocity = last_direction * speed
		update_animation(last_direction)
	
	move_and_slide()
	
	var old_position = position
	position.x = clamp(position.x, min_position.x, max_position.x)
	position.y = clamp(position.y, min_position.y, max_position.y)
	
	if old_position != position:
		last_direction = -last_direction

func update_animation(direction, attacking=false):
	if player_in_range and attacking:
		animated_sprite.play("attack")
		animated_sprite.flip_h = direction.x < 0
		return
	else:
		animated_sprite.play("idle")
	
	animated_sprite.flip_h = false
	
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0

func pick_random_direction():
	var new_direction = Vector2.ZERO
	while new_direction == Vector2.ZERO:
		new_direction = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	new_direction = new_direction.normalized()
	last_direction = new_direction


func _on_slime_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		print("Attacking!")
		animated_sprite.flip_h = position.x > body.position.x

func _on_slime_hitbox_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		print("Player exited hitbox!")
		animated_sprite.flip_h = false

func _on_territory_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		attack = true

func _on_territory_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		attack = false
		pick_random_direction()
		update_animation(last_direction)
