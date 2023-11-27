extends CharacterBody2D


const speed = 400
var direction = "down"
var is_attacking = false
var enemy = null

@onready var anim = $AnimatedSprite2D

func _physics_process(_delta):
	handleInput()
	updateAnim()
	move_and_slide()
	
func handleInput():
	var moveDirection = Input.get_vector("move_left", "move_right",
	"move_up", "move_down",)
	velocity = moveDirection * speed
	if Input.is_action_pressed("attack"):
		is_attacking = true
		$AnimatedSprite2D.visible = false
		
		if enemy is CharacterBody2D:
			enemy.visible = false
		
		if direction == "down":
			$DownAction.visible = true
			$AnimationPlayer.play("down_swing")
		elif direction == "up":
			$UpAction.visible = true
			$AnimationPlayer.play("up_swing")
		elif direction == "side":
			if(anim.flip_h):
				$RightAction.visible = true
				$AnimationPlayer.play("right_swing")
			else:
				$LeftAction.visible = true
				$AnimationPlayer.play("left_swing")

func updateAnim():
	if velocity.length() == 0:
		if anim.is_playing():
			anim.stop()
		anim.play(direction + "_idle")
	else:
		direction = "down"
		if velocity.x < 0 :
			direction = "side"
			anim.flip_h = false
		elif velocity.x > 0:
			direction = "side"
			anim.flip_h = true
		elif velocity.y < 0:
			direction = "up"

		anim.play(direction + "_walk")

func _on_animation_player_animation_finished(anim_name):
	is_attacking = false
	$AnimationPlayer.stop()
	$DownAction.visible = false
	$UpAction.visible = false
	$LeftAction.visible = false
	$RightAction.visible = false
	$AnimatedSprite2D.visible = true

func _on_hit_box_body_entered(body):
	enemy = body


func _on_hit_box_body_exited(body):
	enemy = null
