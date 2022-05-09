extends PlayerState

var blink_timer = 0

func enter(_msg := {}) -> void:
	player.can_double_jump = true
	player.anim_nxt = "Idle"


func physics_update(_delta: float) -> void:
	jump_timer -= delta
	
	if blink_timer == 5:
		player.anim_nxt = "IdleBlink"
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return
		
	if player.is_on_floor():
		if Input.is_action_pressed( "move_left" ) or \
			Input.is_action_pressed( "move_right" ):
				state_machine.transition_to("Run")

	if Input.is_action_just_pressed("move_up"):
		state_machine.transition_to("Jump")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "IdleBlink":
		blink_timer = 0
		player.anim_nxt = "Idle"
	elif anim_name == "Idle":
		blink_timer += 1
	pass # Replace with function body.
