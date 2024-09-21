extends BaseCharacter

signal projectile(scene, facing, projpos)

# Called when the node enters the scene tree for the first time.
func _ready():
	state_action = Neutral
	jump_height = -135
	weight = 20
	speed = 1000
	health = 10000
	meter = 100


func _physics_process(_delta):
	movement()
	dash_check(speed * 0.7)
	# jumping
	gravity($BaseSprite/TimAnimations, $Hitboxes)
	jump($BaseSprite/TimAnimations, "Jumping", "Jumping Idle")
	collision_check(opp)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	define_player()
	inputs()
	face_middle($BaseSprite, $Hitboxes)
	stun_check($BaseSprite/TimAnimations, "Damage")
	
	# movement
	walking($BaseSprite/TimAnimations, "Forward", "Dash")
	timer_indicator($InputTimer)
	
	# idle
	idle($BaseSprite/TimAnimations, "Idle")
	crouching($BaseSprite/TimAnimations, "Crouching", "Crouching Idle")
	blocking($BaseSprite/TimAnimations, "Blocking", "Jump Blocking", "Crouch Blocking")
	
	# attacks
	gt($BaseSprite/TimAnimations, "GT")
	special_command_one($BaseSprite/TimAnimations, "Boxing Glove")
	special_command_two($BaseSprite/TimAnimations, "Command Dash")
	special_command_three($BaseSprite/TimAnimations, "DP")
	special_command_four($BaseSprite/TimAnimations, "Projectile")
	jab($BaseSprite/TimAnimations, "Jumping Jab", "Standing Jab", "Crouching Jab")
	kick($BaseSprite/TimAnimations, "Jumping Kick", "Standing Kick", "Crouching Kick")
	heavy($BaseSprite/TimAnimations, "Jumping Heavy", "Standing Heavy", "Crouching Heavy")
	special($BaseSprite/TimAnimations, "Jumping Special", "Standing Special", "Crouching Special")
	
func standing_jab_hitbox():
	var jabScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/standing_punch_tim.tscn")
	var jab = jabScene.instantiate() as Moves
	$Hitboxes.add_child(jab)
		
func jumping_jab_hitbox():
	var jumpingJabScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/jumping_punch_tim.tscn")
	var jumpingJab = jumpingJabScene.instantiate() as Moves
	$Hitboxes.add_child(jumpingJab)

func crouching_jab_hitbox():
	var crouchingJabScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/crouching_punch_tim.tscn")
	var crouchingJab = crouchingJabScene.instantiate() as Moves
	$Hitboxes.add_child(crouchingJab)

func standing_kick_hitbox():
	var kickScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/standing_kick_tim.tscn")
	var kick = kickScene.instantiate() as Node2D
	$Hitboxes.add_child(kick)

func jumping_kick_hitbox():
	var jumpingKickScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/jumping_kick_tim.tscn")
	var jumpingKick = jumpingKickScene.instantiate() as Node2D
	$Hitboxes.add_child(jumpingKick)

func crouching_kick_hitbox():
	var crouchingKickScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/crouching_kick_tim.tscn")
	var crouchingKick = crouchingKickScene.instantiate() as Moves
	$Hitboxes.add_child(crouchingKick)

func standing_special_hitbox():
	var specialScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/standing_special_tim.tscn")
	var special = specialScene.instantiate() as Moves
	$Hitboxes.add_child(special)
	
func jumping_special_hitbox():
	var jumpingSpecialScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/jumping_special_tim.tscn")
	var jumpingSpecial = jumpingSpecialScene.instantiate() as Moves
	$Hitboxes.add_child(jumpingSpecial)
	
func crouching_special_hitbox():
	var crouchingSpecialScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/crouching_special_tim.tscn")
	var crouchingSpecial = crouchingSpecialScene.instantiate() as Moves
	$Hitboxes.add_child(crouchingSpecial)
	
func standing_heavy_hitbox():
	var heavyScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/standing_heavy_tim.tscn")
	var heavy = heavyScene.instantiate() as Node2D
	$Hitboxes.add_child(heavy)
	
func jumping_heavy_hitbox():
	var jumpingHeavyScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/jumping_heavy_tim.tscn")
	var jumpingHeavy = jumpingHeavyScene.instantiate() as Node2D
	jumpingHeavy.position = $BaseSprite.position
	$Hitboxes.add_child(jumpingHeavy)

func crouching_heavy_hitbox():
	var crouchingHeavyScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/crouching_heavy_tim.tscn")
	var crouchingHeavy = crouchingHeavyScene.instantiate() as Node2D
	$Hitboxes.add_child(crouchingHeavy)

func command_dash_hitbox():
	var commandDashScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/command_dash_tim.tscn")
	var commandDash = commandDashScene.instantiate() as Node2D
	$Hitboxes.add_child(commandDash)
	
func special_command_one_hitbox():
	var commandOneScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/special_command_one_time.tscn")
	var commandOne = commandOneScene.instantiate() as Node2D
	$Hitboxes.add_child(commandOne)
	
func special_command_two_hitbox():
	var commandTwoScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/special_command_two_tim.tscn")
	var commandTwo = commandTwoScene.instantiate() as Node2D
	$Hitboxes.add_child(commandTwo)
	
func special_command_four_hitbox():
	print('ye')
	var commandFourScene: PackedScene = preload("res://AttacksAndHitboxes/Tim/special_command_four_tim.tscn")
	var commandFour = commandFourScene.instantiate() as Node2D
	if face_right():
		projectile.emit(commandFour, 1, $".".global_position)
	else:
		projectile.emit(commandFour, -1, $".".global_position)

func _on_tim_animations_animation_finished(anim_name):
	if state_action == Attacking:
		state_action = Neutral
		dash = false

func _on_input_timer_timeout():
	assign(five)

func _on_hitboxes_child_entered_tree(node):
	define_moves(node)

func _on_anchor_body_entered(body):
	if player == 2 && body != $".":
		body.dash == false
		if body.global_position.x >= $Anchor.global_position.x:
			body.position.x += 75
		elif body.global_position.x < $Anchor.global_position.x:
			body.position.x -= 75
