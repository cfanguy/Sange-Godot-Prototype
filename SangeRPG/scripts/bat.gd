extends CharacterBody2D

var speed = 200
var player_chasing = false
var player = null

func _physics_process(delta):
	if player_chasing:
		position += (player.position - position) / speed
		
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false

func _on_detection_area_body_entered(body):
	player = body
	player_chasing = true


func _on_detection_area_body_exited(body):
	player = null
	player_chasing = false
