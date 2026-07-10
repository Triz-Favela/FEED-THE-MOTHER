extends FishState

var target: Vector2 = Vector2.ZERO
var target_origin: Vector2
var patrol_timer: float = 0

var scared: bool = false

@export var Dead: FishState
@export var Above_water: FishState
@export var Flee: FishState

func enter() -> void:
	scared = false
	patrol_timer = 0
	set_new_point()
	self_fish.connect("got_hurt", set_scared)
	#TODO: Check if this is the best way to make this, it looks like gambiarra
	# but for the time being, thats ok
	player.connect("make_noise", set_scared.bind(true))

func process_frame(delta: float) -> State:
	if patrol_timer <= 0:
		patrol_timer = 5
		set_new_point()
	else:
		patrol_timer -= delta
	
	return null

func process_physics(delta: float) -> State:
	if self_fish.health <= 0:
		return Dead
	
	if scared:
		return Flee
	
	if self_fish.player_in_view and player.velocity.length() > 100:
		return Flee
	
	self_fish.rotation = self_fish.velocity.angle()
	
	self_fish.velocity += self_fish.global_position.direction_to(target) * self_fish.SPEED * delta
	if self_fish.velocity.length() > self_fish.SPEED:
		self_fish.velocity *= 0.99
	
	
	if !self_fish.in_water:
		return Above_water
	
	if self_fish.is_on_wall():
		var wall_normal: Vector2 = self_fish.get_wall_normal()
		target = target.bounce(wall_normal)
		self_fish.velocity = self_fish.velocity.bounce(wall_normal)
	
	self_fish.move_and_slide()
	
	return null

func set_scared(check_player: bool = false) -> void:
	if check_player and !self_fish.player_in_view:
		return
	scared = true

func set_new_point() -> void:
	if self_fish.get_parent() is FishSpawner:
		target_origin = self_fish.get_parent().global_position
	else:
		target_origin = self_fish.global_position
	var new_point: Vector2 = Vector2.UP * randi_range(50,150)
	target = new_point.rotated(randf_range(0, 2*PI)) + target_origin

func exit() -> void:
	self_fish.disconnect("got_hurt", set_scared)
	player.disconnect("make_noise", set_scared)
