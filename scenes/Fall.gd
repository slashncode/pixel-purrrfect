extends PlayerState

var jump_timer : float
var jump_again : bool

func enter(_msg := {}) -> void:
	player.anim_nxt = "Fall"
	pass

func physics_update(delta: float) -> void:
	player.velocity.y = min( player.TERM_VEL, player.velocity.y + player.GRAVITY * delta )
	
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
	
	if Input.is_action_just_pressed( "move_up" ):
		# jump immediately after landing
		jump_timer = obj.JUMP_AGAIN_MARGIN
		jump_again = trueand
		if player.can_double_jump:
			state_machine.transition_to("DoubleJump")
			
	if Input.is_action_just_pressed( "move_up" ):

			
	if player.is_on_floor():
		state_machine.transition_to("Idle")

	# landing
	if player.is_on_floor():
#		fsm.states.punch.has_hit_target = false
		if jump_again and jump_timer >= 0:
			# jump again
			state_machine.transition_to("Jump")
		else:
			# land
			if abs( obj.vel.x ) > 1:
				obj.anim_fx.play( "land_side" )
				fsm.state_nxt = fsm.states.run
			else:
				obj.anim_fx.play( "land" )
				fsm.state_nxt = fsm.states.idle
