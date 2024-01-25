extends CharacterBody2D

const speed = 500
var last_direction = Vector2.ZERO
var animated_sprite
var enemy_in_range = false
var health = 100
var is_dead = false
var is_attacking = false
var attack_timer = 0.0
var attack_duraction = 1.0

func _ready():
	animated_sprite = $AnimatedSprite2D
	add_to_group("Player")

func _physics_process(delta):
	update_health()
	die()
	update_animation()
	move_and_slide()
	
	if is_attacking:
		attack_timer += delta
	if attack_timer >= attack_duraction:
		is_attacking = false
		attack_timer = 0.0
	
func update_animation():
	if is_dead:
		return
	
	if is_attacking:
		if last_direction.y < 0:
			animated_sprite.play("attack_up")
		elif last_direction.y > 0:
			animated_sprite.play("attack_down")
		elif last_direction.x != 0:
			animated_sprite.play("attack_left")
		return
	
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

func _input(event):
	if event.is_action_pressed("ui_select"):
		is_attacking = true
		attack_timer = 0.0

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
		
func die():
	if health <= 0 and not is_dead:
		is_dead = true
		animated_sprite.play("die")


func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemy"):
		enemy_in_range = true
		print("Being Attacked!")


func _on_hitbox_body_exited(body):
	if body.is_in_group("Enemy"):
		enemy_in_range = false
		print("Enemy left hibox!")


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "die":
		queue_free()
