extends FishState

@export var Idle: FishState
@export var Dead: FishState

func process_physics(delta: float) -> State:
	
	if self_fish.in_water:
		return get_parent().previous_state
	
	if self_fish.health <= 0:
		return Dead
	
	if self_fish.is_on_wall():
		var wall_normal: Vector2 = self_fish.get_wall_normal()
		var normal_alignment: float = Vector2.UP.dot(wall_normal)
		if normal_alignment > 0.5:
			self_fish.velocity = (Vector2.UP * 300).rotated(randf_range(PI/6, -PI/6)) 
		else:
			self_fish.velocity = self_fish.velocity.bounce(wall_normal)
	else:
		self_fish.velocity.y += gravity * delta
	
	self_fish.move_and_slide()
	
	return null
