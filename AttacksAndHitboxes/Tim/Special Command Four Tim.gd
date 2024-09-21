extends Moves

var direction
var speed : int = 500

func _ready():
	print('yippee')
	$".".knockback = Vector2(0,0)
	$".".stun_length = 20
	$".".damage = 250
	$HitBoxTimer.start()
	$Sprite2D/AnimationPlayer.play("Spin")

func _process(delta):
	position.x += direction * speed * delta
	
func _on_hit_box_timer_timeout():
	queue_free()

func _on_body_entered(body):
	$".".attack(body)
	queue_free()

func _on_animation_player_animation_finished(anim_name):
	$Sprite2D/AnimationPlayer.play("Spin")
