extends Area2D
class_name Moves

var active_frames
var stun_length
var damage
var knockback: Vector2





func attack(body):
	if !body.is_blocking:
		if body.opp.global_position.x < body.global_position.x:
			body.velocity = knockback
		else:
			body.velocity = Vector2(knockback.x * -1, knockback.y)
		body.stun_duration = stun_length
		body.health -= damage
		body.opp.meter += damage / 25
		body.move_and_slide()
	else:
		if body.opp.global_position.x > body.global_position.x:
			body.opp.velocity.x = damage * 15
		else:
			body.opp.velocity.x = damage * -15
		body.meter += damage / 50
		body.opp.meter += damage / 50
		body.opp.move_and_slide()
