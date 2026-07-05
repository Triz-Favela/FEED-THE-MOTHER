extends FishState

var player_in_view: bool = false

var target: Vector2 = Vector2.ZERO
var patrol_timer: float = 2

@export var Flee: FishState
@export var Dead: FishState

func enter() -> void:
	set_new_point()
	PlayerDetector.connect("body_entered", player_entered)
	PlayerDetector.connect("body_exited", player_exited)

func process_frame(delta: float) -> State:
	if patrol_timer <= 0:
		patrol_timer = 2
		set_new_point()
	else:
		patrol_timer -= delta
	
	return null

func process_physics(delta: float) -> State:
	#if player_in_view:
		#return Flee
	
	if self_fish.health <= 0:
		return Dead
	
	self_fish.rotation = self_fish.velocity.angle()
	
	self_fish.velocity += self_fish.global_position.direction_to(target) * self_fish.SPEED * delta
	if self_fish.velocity.length() > self_fish.SPEED:
		self_fish.velocity *= 0.9
	
	if !self_fish.in_water:
		self_fish.velocity.y += gravity * delta
	
	if self_fish.is_on_wall():
		print("bati")
		var wall_normal: Vector2 = self_fish.get_wall_normal()
		target = target.bounce(wall_normal)
		self_fish.velocity = self_fish.velocity.bounce(wall_normal)
	
	self_fish.move_and_slide()
	
	return null

func set_new_point() -> void:
	var new_point: Vector2 = Vector2.UP * randi_range(50,150)
	target = new_point.rotated(randf_range(0, 2*PI)) + self_fish.global_position

func player_entered(body: Node2D) -> void:
	if body is Player:
		player_in_view = true

func player_exited(body: Node2D) -> void:
	if body is Player:
		player_in_view = false


func exit() -> void:
	PlayerDetector.disconnect("body_entered", player_entered)
	PlayerDetector.disconnect("body_exited", player_exited)
