extends CharacterBody2D
class_name BaseCharacter

var stun_duration : int = 0
var input_direction
var speed
var speedX
var speedY
var opp
var dash = false
var dash_face

var jump_height
var weight
var health
var meter : int = 0
var is_blocking

#controls
var player
var right_input
var left_input
var crouch_input
var jump_input
var jab_input
var kick_input
var heavy_input
var special_input
var gt_input

enum{
	Standing,
	Jumping,
	Crouching
}
var state = Standing

enum{
	Neutral,
	Attacking,
	Stunned
}
var state_action = Neutral

enum{
	yw,
	one,
	two,
	three,
	four,
	five,
	six,
	seven,
	eight,
	nine
}
var direction = [five, five, five, five, five, five, five, five, five, five]
	
func define_player():
	if player == 1:
		right_input = "Right"
		left_input = "Left"
		crouch_input = "Crouch"
		jump_input = "Jump"
		jab_input = "Jab"
		kick_input = "Kick"
		heavy_input = "Heavy"
		special_input = "Special"
		gt_input = "GT"
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
		set_collision_layer_value(5, true)
		set_collision_mask_value(5, true)
		
	else:
		right_input = "RightP2"
		left_input = "LeftP2"
		crouch_input = "CrouchP2"
		jump_input = "JumpP2"
		jab_input = "JabP2"
		kick_input = "KickP2"
		heavy_input = "HeavyP2"
		special_input = "SpecialP2"
		gt_input = "GT2"
		set_collision_layer_value(3, true)
		set_collision_mask_value(3, true)
		set_collision_layer_value(6, true)
		set_collision_mask_value(6, true)
	
func define_moves(move):
	var new_node
	if move.get_class() == "Area2D":
		new_node = move
	else:
		new_node = move.get_child(0).get_child(0).get_child(0)
	if player == 1:
		new_node.set_collision_layer_value(3, true)
		new_node.set_collision_mask_value(3, true)
		new_node.set_collision_layer_value(2, true)
		new_node.set_collision_mask_value(2, true)
		new_node.set_collision_layer_value(1, false)
		new_node.set_collision_mask_value(1, false)
	else:
		new_node.set_collision_layer_value(1, true)
		new_node.set_collision_mask_value(1, true)
		new_node.set_collision_layer_value(2, true)
		new_node.set_collision_mask_value(2, true)
		new_node.set_collision_layer_value(3, false)
		new_node.set_collision_mask_value(3, false)
	
func face_middle(sprite, node):
	if face_left() && state_action != Attacking && node.scale.x > 0:
		sprite.flip_h = true
		node.scale.x *= -1
	if face_right() && state_action != Attacking && node.scale.x < 0:
		sprite.flip_h = false
		node.scale.x *= -1
	
func movement():
	if Input.is_action_pressed(right_input) && (state_action != Attacking || state == Jumping):
		input_direction = 1
	elif Input.is_action_pressed(left_input) && (state_action != Attacking || state == Jumping):
		input_direction = -1
	else:
		input_direction = 0
	if input_direction != 0 and state != Crouching:
		speedX = speed
	else:
		speedX = 0
	if is_blocking && state != Jumping:
		velocity.x = speedX * 0.35 * input_direction
	elif state == Jumping:
		velocity.x = speedX * 0.35 * input_direction
	elif dash == true:
		pass
	elif collision_check(opp):
		velocity.x = lerp(velocity.x, 0.0, 0.0)
		print('bruh')
	else:
		velocity.x = speedX * input_direction
	move_and_slide()
	
func gravity(animation, queue):
	var temp = jump_height
	if !is_on_floor():
		state = Jumping
		velocity.y += weight
		move_and_slide()
	elif state == Jumping:
		#cancel hitboxes when landing
		if queue.get_child_count() > 0:
			queue.get_child(0).queue_free()
		animation.stop()
		dash = false
		state = Standing
		velocity.y = 0
	jump_height = temp
		
func jump(animation, animation_title, jumping_idle):
	if Input.is_action_just_pressed(jump_input) && state == Standing && state_action == Neutral:
		state = Jumping
		speedY = jump_height
		velocity.y = speedY * 5
		animation.play(animation_title)
	if state == Jumping && !animation.is_playing():
		animation.play(jumping_idle)
	
func idle(animation, animation_title):
	if !animation.is_playing() && state == Standing:
		state_action = Neutral
		animation.play(animation_title)
	
func stun_check(animation, animation_title):
	if stun_duration > 0:
		state_action = Stunned
		stun_duration -= 1
	elif state_action == Stunned:
		state_action = Neutral
	if state_action == Stunned:
		animation.play(animation_title)
	
func collision_check(opponent):
	if global_position.x < (opponent.global_position.x + 75) && global_position.x > (opponent.global_position.x - 75) && position.y >= (opponent.position.y - 350):
		print('player: ', position.y)
		print('opponent: ', opponent.position.y)
		if state == Jumping:
			velocity.x = 0
		else:
			opponent.velocity.x = velocity.x
		opponent.move_and_slide()
	
func walking(animation, animation_title_forward, animation_title_dash):
	if state_action != Attacking && Input.is_action_just_pressed(right_input) && double_tap(six) && face_right() && dash == false:
		dash = true
		animation.play(animation_title_dash)
	elif state_action != Attacking && Input.is_action_just_pressed(left_input) && double_tap(four) && face_left() && dash == false:
		dash = true
		animation.play(animation_title_dash)
	if (Input.is_action_pressed(right_input) || Input.is_action_pressed(left_input)) && dash == false && state == Standing && state_action == Neutral:
		animation.play(animation_title_forward)
		
func crouching(animation, animation_title, crouch_idle):
	if Input.is_action_pressed(crouch_input) && state == Standing && state_action != Attacking:
		state = Crouching
		animation.play(animation_title)
	elif state == Crouching && !animation.is_playing():
		animation.play(crouch_idle)
	if Input.is_action_just_released(crouch_input) && state == Crouching:
		state = Standing
			
func blocking(animation, animation_title_blocking, animation_title_jumping, animation_title_crouching):
	if dash == false && (opp.global_position.x > global_position.x && input_direction == -1) || (opp.global_position.x < global_position.x && input_direction == 1):
		is_blocking = true
	else:
		is_blocking = false
	if is_blocking && state_action != Attacking:
		if state == Standing:
			animation.play(animation_title_blocking)
		elif state == Jumping:
			animation.play(animation_title_jumping)
		elif state == Crouching:
			animation.play(animation_title_crouching)
			
func gt(animation, animation_title):
	if Input.is_action_just_pressed(gt_input):
		if meter > 99:
			animation.play(animation_title)
			state_action = Attacking
			meter -= 100
			if global_position.x > opp.global_position.x:
				global_position = Vector2(opp.global_position.x + 100, opp.global_position.y)
			else:
				global_position = Vector2(opp.global_position.x - 100, opp.global_position.y)
			if !opp.is_blocking:
				opp.stun_duration += 30
			
func jab(animation, animation_title_jumping, animation_title_standing, animation_title_crouching):
	if Input.is_action_just_pressed(jab_input) && state_action == Neutral && state_action != Attacking:
		assign(five)
		state_action = Attacking
		if state == Jumping:
			animation.play(animation_title_jumping)
		elif state == Standing:
			dash = false
			animation.play(animation_title_standing)
		elif state == Crouching:
			animation.play(animation_title_crouching)
			
func kick(animation, animation_title_jumping, animation_title_standing, animation_title_crouching):
	if Input.is_action_just_pressed(kick_input) && state_action == Neutral && state_action != Attacking:
		assign(five)
		state_action = Attacking
		if state == Jumping:
			animation.play(animation_title_jumping)
		elif state == Standing:
			dash = false
			animation.play(animation_title_standing)
		elif state == Crouching:
			animation.play(animation_title_crouching)
			
func heavy(animation, animation_title_jumping, animation_title_standing, animation_title_crouching):
	if Input.is_action_just_pressed(heavy_input) && state_action == Neutral && state_action != Attacking:
		assign(five)
		state_action = Attacking
		if state == Jumping:
			animation.play(animation_title_jumping)
		elif state == Standing:
			dash = false
			animation.play(animation_title_standing)
		elif state == Crouching:
			animation.play(animation_title_crouching)
			
func special(animation, animation_title_jumping, animation_title_standing, animation_title_crouching):
	if Input.is_action_just_pressed(special_input) && state_action == Neutral && state_action != Attacking:
		assign(five)
		state_action = Attacking
		if state == Jumping:
			animation.play(animation_title_jumping)
		elif state == Standing:
			dash = false
			animation.play(animation_title_standing)
		elif state == Crouching:
			animation.play(animation_title_crouching)
			
func special_command_one(animation, animation_title):
	if Input.is_action_just_pressed(special_input) && dash == false && state_action != Attacking && state != Jumping:
		if face_right() && quarter_circle_forward():
			assign(five)
			animation.play(animation_title)
			state_action = Attacking
		if face_left() && quarter_circle_backward():
			assign(five)
			animation.play(animation_title)
			state_action = Attacking

func special_command_two(animation, animation_title):
	if Input.is_action_pressed(kick_input) && state_action != Attacking && state != Jumping:
		if face_right() && quarter_circle_backward():
			assign(five)
			animation.play(animation_title)
			state_action = Attacking
		if face_left() && quarter_circle_forward():
			assign(five)
			animation.play(animation_title)
			state_action = Attacking

func special_command_three(animation, animation_title):
	if Input.is_action_pressed(jab_input) && dash == false && state_action != Attacking && state != Jumping:
		if face_right() && z_input_forward():
			assign(five)
			state_action = Attacking
			animation.play(animation_title)
		if face_left() && z_input_backward():
			assign(five)
			state_action = Attacking
			animation.play(animation_title)

func special_command_four(animation, animation_title):
	if Input.is_action_just_pressed(kick_input) && dash == false && state_action != Attacking && state != Jumping:
		if face_right() && quarter_circle_forward():
			assign(five)
			animation.play(animation_title)
			state_action = Attacking
		if face_left() && quarter_circle_backward():
			assign(five)
			animation.play(animation_title)
			state_action = Attacking

func dash_check(move):
	if dash:
		velocity.x = move * dash_face
		move_and_slide()
	
func dash_set(boov):
	if boov == true:
		dash = true
		if face_right():
			dash_face = 1
		else:
			dash_face = -1
	else:
		dash = false
	
func bounce(height):
	velocity.y = height
	state = Jumping
	move_and_slide()

func return_neutral():
	state = Neutral

func face_right():
	if global_position.x < opp.global_position.x:
		return true
		
func face_left():
	if global_position.x > opp.global_position.x:
		return true

func inputs():
	three_input()
	one_input()
	two_input()
	four_input()
	six_input()
	#print(direction)
	
func timer_indicator(timer):
	if Input.is_anything_pressed():
		timer.start()
	
func quarter_circle_forward():
	if direction[0] == six && direction [1] == three && direction [2] == two:
		return true
	
func quarter_circle_backward():
	if direction[0] == four && direction [1] == one && direction [2] == two:
		return true
	
func  z_input_forward():
	if direction[0] == three && direction [1] == two && direction [2] == six:
		return true
		
func  z_input_backward():
	if direction[0] == one && direction [1] == two && direction [2] == four:
		return true
	
func double_tap(input):
	if direction[0] == input && direction[1] == input:
		return true
	
func six_input():
	if Input.is_action_pressed(right_input) && direction[0] != six:
		if !Input.is_action_pressed(crouch_input):
			assign(six)
	elif Input.is_action_just_pressed(right_input):
		if !Input.is_action_pressed(crouch_input):
			assign(six)
	
func four_input():
	if Input.is_action_pressed(left_input) && direction[0] != four:
		if !Input.is_action_pressed(crouch_input):
			assign(four)
	elif Input.is_action_just_pressed(left_input):
		if !Input.is_action_pressed(crouch_input):
			assign(four)
	
func three_input():
	if Input.is_action_just_pressed(right_input):
		if Input.is_action_pressed(crouch_input):
			assign(three)
	if Input.is_action_just_pressed(crouch_input):
		if Input.is_action_pressed(right_input):
			assign(three)
	
func two_input():
	if Input.is_action_pressed(crouch_input) && direction[0] != two:
		if !Input.is_action_pressed(right_input) && !Input.is_action_pressed(left_input):
			assign(two)
	
func one_input():
	if Input.is_action_just_pressed(left_input):
		if Input.is_action_pressed(crouch_input):
			assign(one)
	if Input.is_action_just_pressed(crouch_input):
		if Input.is_action_pressed(left_input):
			assign(one)
	
func assign(dir):
	direction.pop_back()
	direction.push_front(dir)
