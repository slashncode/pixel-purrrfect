extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const MAXFALLSPEED = 260
const MAXSPEED = 160
const JUMPFORCE = 300
const ACCEL = 10

var can_doublejump = false
var facing_right = true
var fall_animation_played = false
var land_animation_played = true
var has_walljumped = false
var blink_timer = 0
var sit_timer = 0
var is_on_wall_timer = 0

var motion = Vector2()
func _ready():
	pass

func _physics_process(delta):
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
		
	if facing_right == true:
		$Sprite.scale.x = 1
	else:
		$Sprite.scale.x = -1
		
	motion.x = clamp(motion.x,-MAXSPEED, MAXSPEED)
	
	if sit_timer < 10:
		$Camera2D.zoom.x = lerp($Camera2D.zoom.x, 0.5, 0.01)
		$Camera2D.zoom.y = lerp($Camera2D.zoom.y, 0.5, 0.01)

		$Camera2D.position.x = lerp($Camera2D.position.x, 90, 0.01)
		$Camera2D.position.y = lerp($Camera2D.position.y, -20, 0.01)
		#$Camera2D.transform.x = lerp($Camera2D.transform.x, 90, 0.01)
		#$Camera2D.transform.y = lerp($Camera2D.transform.y, -20, 0.01)

	if Input.is_action_pressed("move_right"):
		motion.x += ACCEL
		facing_right = true
		sit_timer = 0
		if is_on_floor() and land_animation_played == true:
			$AnimationPlayer.play("Run")
		elif !is_on_floor() and is_on_wall() and is_on_wall_timer < 120:
			motion.y = 0
			can_doublejump = true
			fall_animation_played = false
			is_on_wall_timer += 1
			if Input.is_action_pressed("move_up"):
				motion.y -= 30
				$AnimationPlayer.play("Wallclimb")
			else:
				$AnimationPlayer.play("Wallgrab")
	elif Input.is_action_pressed("move_left"):
		motion.x -= ACCEL
		facing_right = false
		sit_timer = 0
		if is_on_floor() and land_animation_played == true:
			$AnimationPlayer.play("Run")
		elif !is_on_floor() and is_on_wall() and is_on_wall_timer < 120:
			motion.y = 0
			can_doublejump = true
			fall_animation_played = false
			is_on_wall_timer += 1
			if Input.is_action_pressed("move_up"):
				motion.y -= 30
				$AnimationPlayer.play("Wallclimb")
			else:
				$AnimationPlayer.play("Wallgrab")
	else:
		motion.x = lerp(motion.x,0,0.2)
		if is_on_floor():
			if land_animation_played == true:
				if sit_timer == 10:
					$Camera2D.zoom.x = lerp($Camera2D.zoom.x, 0.2, 0.01)
					$Camera2D.zoom.y = lerp($Camera2D.zoom.y, 0.2, 0.01)
					
					$Camera2D.position.x = lerp($Camera2D.position.x, 0, 0.01)
					$Camera2D.position.y = lerp($Camera2D.position.y, 0, 0.01)
					$AnimationPlayer.play("SitIdle")
				elif blink_timer == 2 and sit_timer != 10:
					$AnimationPlayer.play("Blink")
				else:
					$AnimationPlayer.play("Idle")
			can_doublejump = true
			fall_animation_played = false
			
	if !is_on_floor() and motion.y > 0 and fall_animation_played == false:
		$AnimationPlayer.play("Fall")
		fall_animation_played = true
		land_animation_played = false
		
	if Input.is_action_just_pressed("dash"):
		if facing_right == true:
			motion = Vector2(2000, 0)
		else:
			motion = Vector2(-2000, 0)
			
	if is_on_floor():
		is_on_wall_timer = 0
		if land_animation_played == false:
			$AnimationPlayer.play("Land")

	if is_on_floor() or is_on_wall():
		if Input.is_action_just_pressed("jump"):
			$AnimationPlayer.play("Jump")
			motion.y = -JUMPFORCE
			fall_animation_played = false
			if !is_on_wall():
				is_on_wall_timer = 0
			
	if !is_on_floor() and can_doublejump:
		if Input.is_action_just_pressed("jump"):
			$AnimationPlayer.play("Jump")
			motion.y = -JUMPFORCE
			can_doublejump = false
			fall_animation_played = false
			if !is_on_wall():
				is_on_wall_timer = 0

	if Input.is_action_just_released("jump") and motion.y < 0:
		motion.y =-10

	motion = move_and_slide(motion, UP)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Land":
		land_animation_played = true
	if anim_name == "Idle":
		blink_timer += 1
		sit_timer += 1
	if anim_name == "Blink":
		blink_timer = 0
		sit_timer += 1
