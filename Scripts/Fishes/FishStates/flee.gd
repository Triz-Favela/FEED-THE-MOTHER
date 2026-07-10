extends FishState

const flee_timer_start_value: float = 5
var flee_timer: float = flee_timer_start_value

var SPEED_MULTIPLIER: float = 10
var swimming_direction: Vector2 = Vector2.ZERO

@export var Idle: FishState
@export var Above_water: FishState
@export var Dead: FishState

func enter() -> void:
	flee_timer = flee_timer_start_value
	#swimming_direction = player.global_position.direction_to(self_fish.global_position)
	#self_fish.velocity = swimming_direction * (self_fish.SPEED * SPEED_MULTIPLIER)

func process_frame(delta: float) -> State:
	# If the timer is running, return null
	if flee_timer > 0:
		flee_timer -= delta
		return null
	# If the player is in view, resets the timer and returns null
	if self_fish.player_in_view and player.velocity.length() > 50:
		flee_timer = flee_timer_start_value
		return null
	# Else, return to the idle state
	else:
		return Idle

func process_physics(delta: float) -> State:
	# Checks the health, if its zero or less, return the dead state
	if self_fish.health <= 0:
		return Dead
	
	#self_fish.rotation = lerp_angle(self_fish.rotation, self_fish.velocity.angle(), 1.0 - exp(-10 * delta))
	self_fish.rotation = self_fish.velocity.angle()
	
	if player:
		swimming_direction = player.global_position.direction_to(self_fish.global_position)
		self_fish.velocity += swimming_direction * (self_fish.SPEED * SPEED_MULTIPLIER * 2 * delta)
		if self_fish.velocity.length() > self_fish.SPEED * SPEED_MULTIPLIER/2:
			self_fish.velocity *= 0.9
	
	
	if !self_fish.in_water:
		return Above_water
	
	if self_fish.is_on_wall():
		var wall_normal: Vector2 = self_fish.get_wall_normal()
		self_fish.velocity = self_fish.velocity.bounce(wall_normal)
		
	self_fish.move_and_slide()
	return null
