extends CharacterBody2D


const speed = 300
var direction = "down"

@onready var anim = $AnimatedSprite2D

func _physics_process(_delta):
	handleInput()
	updateAnim()
	move_and_slide()
	
func handleInput():
	var moveDirection = Input.get_vector("move_left", "move_right",
	"move_up", "move_down",)
	velocity = moveDirection * speed

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
	
