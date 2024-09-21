extends Moves

func _ready():
	$".".knockback = Vector2(50,-50)
	$".".active_frames = 1
	$".".stun_length = 3
	$".".damage = 60
	$HitBoxTimer.wait_time = 0.03 * active_frames
	$HitBoxTimer.start()

func _process(delta):
	pass
	
func _on_hit_box_timer_timeout():
	queue_free()

func _on_body_entered(body):
	$".".attack(body)  
