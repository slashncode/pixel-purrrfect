# Character that moves and jumps.
class_name Player
extends KinematicBody2D

# Horizontal speed in pixels per second.
export var SPEED := 100.0
# Vertical acceleration in pixel per second squared.
export var GRAVITY = 600.0
# Vertical speed applied when jumping.
export var JUMP_IMPULSE := 300.0
# Maximum gravity
export var TERM_VEL := 250.0

const JUMP_VEL = -150.0
const MAX_VEL = 100
const AIR_ACCEL = 10

export var can_double_jump := false

var velocity = Vector2.ZERO

var anim_cur = ""
var anim_nxt = "Idle"

var dir_cur = 1
var dir_nxt = 1

var is_invulnerable := false
var invulnerable_timer := 0.0

onready var fsm := $StateMachine


func _physics_process(_delta: float) -> void:
	
	if anim_cur == "Idle" and anim_nxt == "Idle":
		$AnimationPlayer.play("Idle")
	
	if anim_cur != anim_nxt:
		anim_cur = anim_nxt
		$AnimationPlayer.play( anim_cur )
		
	if dir_cur != dir_nxt:
		dir_cur = dir_nxt
		$player.scale.x = dir_cur
		
	if velocity.x < 0:
		dir_nxt = -1
	elif velocity.x > 0:
		dir_nxt = 1
		
	#label.text = fsm.state.name
	pass
