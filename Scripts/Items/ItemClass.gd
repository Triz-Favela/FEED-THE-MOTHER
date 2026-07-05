extends CharacterBody2D
class_name Item

@export var display_name:String = "Placeholder"
@export var weight:float

var in_water: bool = false
var WATER_DRAG: float = 0.95
var WATER_DRAG_GRAVITY: float = 10

var picked: bool = false
var pickable: bool = false
var timer: float = 0.2
var stopped: bool = false

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	# Disable default layer and collision layer values
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	# Set the correct ones
	set_collision_mask_value(4, true)

func _physics_process(delta: float) -> void:
	unpicked_item_physics(delta)

func unpicked_item_physics(delta: float) -> void:
	# If the item is picked, then it returns
	if picked:
		return
	# The item sets a condition to be pickable
	# a timer of 0.2 second is the default, to prevent it to be pickable right 
	# after the player drops it
	pickable = pickable_condition(delta)
	
	# if the item stopped, it return the rotation to zero, 
	# so it can lay down flat on the ground
	if !stopped:
		rotation = lerp_angle(rotation, velocity.angle(), 0.9)
	else:
		rotation = lerp_angle(rotation, 0, 0.2)
	# It bounces on the walls
	bounce_in_wall()
	
	# If its on water, the velocity gradually decreases
	if in_water:
		water_physics(delta)
	# Else, it justs runs the normal gravity
	else:
		velocity.y += gravity * delta
	
	move_and_slide()

func pickable_condition(delta: float) -> bool:
	if timer <= 0:
		return true
	else:
		timer -= delta
	return false

func bounce_in_wall() -> void:
	if !is_on_wall():
		return
	
	var normal_alignment: float = Vector2.UP.dot(get_wall_normal())
	if normal_alignment < 0.5 or velocity.length() > 150:
		velocity = velocity.bounce(get_wall_normal()) * 0.5
	else:
		velocity = Vector2.ZERO
		stopped = true
	
	#if !stopped and velocity.length() > 150:
		#velocity = velocity.bounce(get_wall_normal()) * 0.5
	#elif normal_alignment > 0.5:
			#velocity = Vector2.ZERO
			#stopped = true
		
	
	
	
func water_physics(delta: float) -> void:
	velocity = velocity * 0.95
	velocity.y += gravity/10 * delta

func action() -> void:
	print("estou sendo usado :(")
