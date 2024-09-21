extends Moves

func _ready():
	$".".knockback = Vector2(250,0)
	$".".active_frames = 8
	$".".stun_length = 1
	$"../../HitBoxTimer".wait_time = 0.03 * active_frames
	$"../../HitBoxTimer".start()
	$SecondHitBox.disabled = true

func _process(delta):
	pass
	
func _on_hit_box_timer_timeout():
	if $SecondHitBox.disabled != false:
		$SecondHitBox.disabled = false
		print($SecondHitBox.disabled)
		$"../../HitBoxTimer".start()
		active_frames = 3
		$"../../HitBoxTimer".wait_time = 0.03 * active_frames
	else:
		queue_free()

func _on_body_entered(body):
	$".".attack(body)  

