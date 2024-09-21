extends Moves

func _ready():
	$".".knockback = Vector2(500,100)
	$".".active_frames = 4
	$".".stun_length = 10
	$".".damage = 130
	$"../../HitBoxTimer".wait_time = 0.03 * active_frames
	$"../../HitBoxTimer".start()
	$"Crouching Heavy Two/Crouching Heavy Two Box".disabled = true

func _process(delta):
	if $"Crouching Heavy Two".get_collision_layer() == 6:
		$".".set_collision_layer_value(3, true)
		$".".set_collision_mask_value(3, true)
	if $"Crouching Heavy Two".get_collision_layer() == 3:
		$".".set_collision_layer_value(1, true)
		$".".set_collision_mask_value(1, true)
	
func _on_hit_box_timer_timeout():
	if $"Crouching Heavy Two/Crouching Heavy Two Box".disabled != false:
		$"Crouching Heavy Two/Crouching Heavy Two Box".disabled = false
		active_frames = 2
		$"../../HitBoxTimer".wait_time = 0.03 * active_frames
		$"../../HitBoxTimer".start()
	else:
		queue_free()

func _on_body_entered(body):
	$".".attack(body)  

func _on_crouching_heavy_two_body_entered(body):
	knockback = Vector2(-2000,250)
	$".".attack(body)
