extends PlayerState

var keypress_timer : float

func enter(_msg := {}) -> void:
	player.velocity.y = -player.JUMP_IMPULSE
	keypress_timer = 0.2
	player.anim_nxt = "Jump"

func physics_update(delta: float) -> void:
	if base_jump( delta ):
		return
	if Input.is_action_just_pressed( "move_up" ) and \
		player.can_double_jump:
			state_machine.transition_to("DoubleJump")
			return

func base_jump( delta ) -> bool:
	print(player.velocity.y)
	player.velocity.y = min( player.TERM_VEL, player.velocity.y + player.GRAVITY * delta )
	if keypress_timer >= 0:
		keypress_timer -= delta
		if keypress_timer < 0 or Input.is_action_just_released( "move_up" ):
			keypress_timer = -1.0
			player.velocity.y *= 0.2
	
	var dir = Input.get_action_strength( "move_right" ) - \
		Input.get_action_strength( "move_left" )
	
	var is_moving = ( abs( dir ) > 0.1 )
	#print( is_moving )
	if is_moving:
		dir = sign( dir )
		player.velocity.x = lerp( player.velocity.x, \
			player.MAX_VEL * dir, \
			player.AIR_ACCEL * delta )
		player.dir_nxt = dir
	else:
		player.velocity.x = lerp( player.velocity.x, 0, \
			player.AIR_ACCEL * delta )
	
	player.velocity = player.move_and_slide( player.velocity, \
			Vector2.UP )
	
	if player.is_on_ceiling():
		player.velocity.y = 0.0
		state_machine.transition_to("Fall")
	elif player.velocity.y > 0:
		state_machine.transition_to("Fall")
	
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	return false
