extends CharacterBody2D
class_name AirBubble

var in_water: bool = false
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var air_amount: float = 10

func _ready() -> void:
	$Area2D.connect("body_entered", body_entered)

func _physics_process(delta: float) -> void:
	velocity.y -= gravity/10 * delta
	if velocity.y < -200:
		velocity.y = -200
	move_and_slide()
	await get_tree().physics_frame
	if in_water == false:
		queue_free()

func body_entered(_body: Node2D) -> void:
	queue_free()
