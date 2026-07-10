extends Item

var stuck: bool = false

func unpicked_item_physics(delta: float) -> void:
	# If the spear is picked or stuck, then it returns
	if picked:
		return
	
	
	# The item sets a condition to be pickable
	pickable = pickable_condition(delta)
	
	if stuck:
		return
	
	rotation = lerp_angle(rotation, velocity.angle(), 0.9)
	
	# If its on water, the velocity gradually decreases
	if in_water:
		water_physics(delta)
	# Else, it justs runs the normal gravity
	else:
		velocity.y += gravity * delta
	
	move_and_slide()

func pickable_condition(delta: float) -> bool:
	if timer <= 0: 
		if (stuck or velocity.length() < 50):
			return true
	else:
		timer -= delta
	return false


func _on_damage_body_entered(body: Node2D) -> void:
	if stuck or picked or ("health" in body and body.health <= 0):
		return
	
	if body is Fish and velocity.length() > 100:
		body.health -= 1
		position += body.velocity * body.get_physics_process_delta_time()
		body.SPEED -= body.SPEED/3
		if body.health <= 0:
			picked = true
			pickable = false
			for node: Node in body.get_children():
				if node is Item:
					node.picked = true
					node.pickable = false
		
	velocity = Vector2.ZERO
	stuck = true
	
	call_deferred("reparent", body)
