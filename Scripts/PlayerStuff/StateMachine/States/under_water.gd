extends PlayerState

@export_group("States")
@export var air: PlayerState

func enter():
	player.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	Anim_state_machine.travel("Swimming")
	
func process_physics(delta):
	var water_gravity = 20
	player.position.y += water_gravity*delta
	player.rotation = lerp_angle(player.rotation, player.velocity.angle() + deg_to_rad(90), 0.3)
	#rotation = velocity.angle() + deg_to_rad(90)
	
	
	var direction = Input.get_vector("LEFT", "RIGHT","UP", "DOWN")

	if direction:
		player.velocity += direction * player.ACCEL * delta
		if player.velocity.length() > player.SWIM_MAX_SPEED:
			player.velocity = player.velocity.normalized() * player.SWIM_MAX_SPEED
		
	elif player.velocity.length() > 0:
		player.velocity = player.velocity * 0.95
	
	if player.get_slide_collision_count() > 0:
		player.velocity = player.velocity * 0.9
	
	if !player.get_node("BreathManager").in_water:
		player.velocity.y = player.JUMP_VELOCITY
		return air
	
	Anim_tree.set("parameters/Swimming/SwimmingSpeed/scale", (player.velocity.length()/player.SWIM_MAX_SPEED) + 0.1)
