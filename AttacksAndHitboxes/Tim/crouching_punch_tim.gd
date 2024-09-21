extends Moves

func _ready():
	$".".knockback = Vector2(800,-170)
	$".".active_frames = 2
	$".".stun_length = 20
	$".".damage = 125
	$HitBoxTimer.wait_time = 0.03 * active_frames
	$HitBoxTimer.start()

func _process(delta):
	pass
	
func _on_hit_box_timer_timeout():
	queue_free()

func _on_body_entered(body):
	$".".attack(body)  

