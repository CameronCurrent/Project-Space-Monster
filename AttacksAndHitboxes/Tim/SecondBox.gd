extends Moves

func _ready():
	$".".knockback = Vector2(100,-100)
	$".".active_frames = 1
	$".".stun_length = 6
	$SecondHitBox.disabled = true

func _process(delta):
	pass
	
func _on_hit_box_timer_timeout():
	if $SecondHitBox.disabled == false:
		queue_free()

func _on_body_entered(body):
	$".".attack(body)  

