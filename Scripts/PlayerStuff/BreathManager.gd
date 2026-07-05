extends CharacterBody2D
class_name BreathManager

var in_water: bool = false

var breath:float = 10
var out_of_breath: bool = false:
	set(new_value):
		if new_value == true and new_value != out_of_breath:
			out_of_breath = new_value
			out_of_breath_damage()
			return
		out_of_breath = new_value

func _physics_process(delta: float) -> void:
	if in_water:
		breath -= 5*delta
	else:
		breath += 10*delta
	
	breath = clamp(breath, 0, 100)
	
	if breath <= 0:
		out_of_breath = true
	else:
		out_of_breath = false

func out_of_breath_damage() -> void:
	await get_tree().create_timer(1.5).timeout
	get_parent().health -= 10
	if out_of_breath:
		out_of_breath_damage()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is AirBubble:
		breath += body.air_amount/1.5
		body.queue_free()
