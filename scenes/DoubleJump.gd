extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity.y = player.JUMP_VEL
	player.can_double_jump = false
	pass

func physics_update(_delta: float) -> void:
	state_machine.transition_to("Jump")
	return
