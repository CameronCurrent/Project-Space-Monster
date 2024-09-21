extends CharacterBody2D

var weight = 25

func _process(delta):
	if !is_on_floor():
			velocity.y += weight
			move_and_slide()
