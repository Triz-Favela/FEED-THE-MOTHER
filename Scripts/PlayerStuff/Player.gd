extends CharacterBody2D
class_name Player

var health:float = 100

var ACCEL = 1000.0
var MAX_RUN_SPEED = 230.0
var JUMP_VELOCITY = -350.0
var SWIM_MAX_SPEED = 300.0

var flipped:int = -1

var in_water = false

var mouse_in_window:bool = true


func _process(_delta):
	if Input.is_action_just_pressed("ui_home"):
		Engine.time_scale = 0.2
	if Input.is_action_just_released("ui_home"):
		Engine.time_scale = 1
	if mouse_in_window:
		$Camera2D.position = get_local_mouse_position()/7

func _physics_process(_delta):
	var head_angle = get_angle_to(get_global_mouse_position())
	if head_angle > -1.5 and head_angle < 1.5:
		flipped = -1
	else:
		flipped = 1
	
	if mouse_in_window:
		$Player_visuals.scale.x = 0.15 * flipped
	
	if !(head_angle < 2.5 and head_angle > 0.5) and mouse_in_window:
		get_node("Player_visuals/Skeleton2D/root/UpperBody/Head").scale = Vector2(1,1) * flipped
		get_node("Player_visuals/Skeleton2D/root/UpperBody/Head").rotation = (head_angle + deg_to_rad(75 * flipped)) * flipped
	  
	health = clamp(health, 0, 100)
	move_and_slide()
	

func update_velocity(weight):
	SWIM_MAX_SPEED = 275.0 - (weight * 2)
	MAX_RUN_SPEED = 300.0 - (weight * 2)
	JUMP_VELOCITY = -350.0 + (weight * 3)
