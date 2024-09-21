extends Moves

func _ready():
	$".".knockback = Vector2(3000,-150)
	$".".active_frames = 12.6
	$".".stun_length = 40
	$".".damage = 200
	$HitBoxTimer.wait_time = 0.03 * active_frames
	$HitBoxTimer.start()

func _process(delta):
	$".".get_parent().set_progress($".".get_parent().get_progress() + 935 * delta)
	
func _on_hit_box_timer_timeout():
	queue_free()


func _on_body_entered(body):
	$".".attack(body)
	queue_free()
