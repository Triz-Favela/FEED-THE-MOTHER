extends StaticBody2D
class_name AirGeyser

var bubble: PackedScene = preload("res://Scenes/Enviroment/AirGeyser/airBubble.tscn")
var rand_value:float

var geyser_active: bool = true

func _ready() -> void:
	start_geyser()

func start_geyser() -> void:
	if !geyser_active:
		return
	rand_value = randf_range(0.7,1.5)
	await get_tree().create_timer(rand_value).timeout
	var instance: AirBubble = bubble.instantiate()
	call_deferred("add_child", instance)
	instance.position = Vector2(0,-20)
	instance.scale = instance.scale * rand_value
	instance.air_amount = instance.air_amount * rand_value
	start_geyser()
