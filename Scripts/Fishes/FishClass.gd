extends Item
class_name Fish

var new_point: Vector2
@export var patrol_range: Vector2 = Vector2(50, 100)
@export var speed: float = 50
@export var health: int = 1
@export var view_range: float = 0



func _ready():
	super()
	create_new_point()

func _physics_process(delta):
	if !picked:
		if health > 0:
			fish_physics(delta)
		else:
			unpicked_item_physics(delta)

func fish_physics(delta):
	rotation = velocity.angle()
	if not in_water:
		if is_on_wall():
			if !get_wall_normal().dot(Vector2(0,1)) < 0.9:
				velocity = velocity.bounce(get_wall_normal()) * 0.2
			else:
				velocity = Vector2(0, -speed * 6).rotated(270 * randi_range(-1,1))
		velocity.y += gravity/2 * delta
		move_and_slide()
		return
	
	#if is_instance_valid(player):
		#var distance = (global_position - player.global_position).length()
		#
		#if distance < view_range and player.in_water:
			#escape(delta)
		#else:
			#idle(delta)
	
	if is_on_wall():
		
		velocity = velocity.bounce(get_wall_normal()) * 0.9
	move_and_slide()
#
#func escape(delta):
	#velocity += (global_position - player.global_position).normalized() * speed * 10 * delta
	#if velocity.length() > speed*5:
		#velocity = velocity.normalized() * speed*5

func idle(delta):
	velocity += global_position.direction_to(new_point) * speed * delta
	if velocity.length() > speed:
		velocity = velocity * 0.99
	#
	if (global_position - new_point).length() < 50:
		create_new_point()

func create_new_point():
	if get_parent() is Node2D:
		new_point = get_parent().global_position + Vector2(0, randf_range(patrol_range.x, patrol_range.y)).rotated(randi())
