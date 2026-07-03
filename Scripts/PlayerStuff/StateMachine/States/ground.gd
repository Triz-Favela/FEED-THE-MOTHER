extends PlayerState

@export_group("States")
@export var air: PlayerState
@export var under_water: PlayerState

func enter() -> void:
	player.motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	
	var direction: float = Input.get_axis("LEFT","RIGHT")
	if direction:
		player.velocity.x += player.ACCEL * delta * direction
		if abs(player.velocity.x) > player.MAX_RUN_SPEED:
			player.velocity.x = direction * player.MAX_RUN_SPEED
		Anim_state_machine.travel("Running")
	else:
		Anim_state_machine.travel("Idle")
		player.velocity.x *= 0.85
	
	if player.is_on_floor() and Input.is_action_just_pressed("UP"):
		player.velocity.y = player.JUMP_VELOCITY
	
	if !player.is_on_floor():
		return air
	
	if player.get_node("BreathManager").in_water:
		return under_water
	
	return null
