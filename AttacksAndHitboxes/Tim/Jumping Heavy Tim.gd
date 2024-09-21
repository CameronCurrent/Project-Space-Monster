extends Moves

func _ready():
	$".".knockback = Vector2(500,100)
	$".".active_frames = 5
	$".".stun_length = 10
	$".".damage = 125
	$"../../HitBoxTimer".wait_time = 0.03 * active_frames
	$"../../HitBoxTimer".start()
	$"Box Two/SecondHitBox".disabled = true

func _process(delta):
	if $"Box Two".get_collision_layer() == 6:
		$".".set_collision_layer_value(3, true)
		$".".set_collision_mask_value(3, true)
	if $"Box Two".get_collision_layer() == 3:
		$".".set_collision_layer_value(1, true)
		$".".set_collision_mask_value(1, true)
	
func _on_hit_box_timer_timeout():
	if $"Box Two/SecondHitBox".disabled != false:
		$"Box Two/SecondHitBox".disabled = false
		active_frames = 2
		$"../../HitBoxTimer".wait_time = 0.03 * active_frames
		$"../../HitBoxTimer".start()
	else:
		queue_free()

func _on_body_entered(body):
	$".".attack(body)  

func _on_box_two_body_entered(body):
	$".".attack(body)
