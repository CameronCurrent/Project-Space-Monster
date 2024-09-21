extends Moves

func _ready():
	$".".knockback = Vector2(1000,200)
	$".".active_frames = 11.5
	$".".stun_length = 15
	$".".damage = 275
	$HitBoxTimer.wait_time = 0.03 * active_frames
	$HitBoxTimer.start()

func _process(delta):
	$".".get_parent().set_progress($".".get_parent().get_progress() + 1400 * delta)
	
func _on_hit_box_timer_timeout():
	queue_free()


func _on_body_entered(body):
	$".".attack(body)
	knockback = Vector2(2000,-500)
	$".".attack(body)
	queue_free()
