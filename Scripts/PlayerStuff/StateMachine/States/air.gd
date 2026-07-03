extends PlayerState

@export_group("States")
@export var ground: PlayerState
@export var under_water: PlayerState

var jump_buffer:float = 0.1
var jump_timer:float = 1
var jump_qntt:int = 3
var coyote_time:float = 0.15

func enter():
	player.motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	Anim_state_machine.travel("Jumping")
	jump_qntt = 2
	jump_timer = 1
	coyote_time = 0.15

func process_physics(delta):
	player.velocity.y += gravity * delta
	player.rotation = lerp_angle(player.rotation, 0.0, 0.3)
	jump_timer -= delta
	jump_buffer -= delta
	coyote_time -= delta
	
	var direction = Input.get_axis("LEFT","RIGHT")
	if direction:
		player.velocity.x += player.ACCEL * delta * direction
		if abs(player.velocity.x) > player.MAX_RUN_SPEED:
			player.velocity.x = direction * player.MAX_RUN_SPEED
	else:
		player.velocity.x *= 0.9
	
	if Input.is_action_pressed("UP") and jump_timer > 0:
		player.velocity.y += player.JUMP_VELOCITY * delta
	
	if Input.is_action_just_pressed("UP"):
		if jump_qntt > 0:
			Anim_state_machine.travel("Jumping")
			player.velocity.y = player.JUMP_VELOCITY
			jump_timer = 1
			if coyote_time <= 0:
				jump_qntt -= 1
		else:
			jump_buffer = 0.1
	
	if Input.is_action_just_released("UP"):
		jump_timer = 0
	
	
	if player.is_on_floor():
		if jump_buffer > 0:
			player.velocity.y = player.JUMP_VELOCITY
			return self
		else:
			return ground
	
	if player.get_node("BreathManager").in_water:
		return under_water
	
	if player.velocity.y > 0:
		Anim_state_machine.travel("Falling")
	
	return null
