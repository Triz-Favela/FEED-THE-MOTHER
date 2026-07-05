extends Area2D
class_name Water

func _on_body_entered(body: Node2D) -> void:
	if "in_water" in body:
		body.in_water = true

func _on_body_exited(body: Node2D) -> void:
	if "in_water" in body:
		body.in_water = false
