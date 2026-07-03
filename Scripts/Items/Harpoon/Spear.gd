extends Item

var stuck: bool = false

func unpicked_item_physics(delta: float) -> void:
	# If the spear is picked or stuck, then it returns
	if picked:
		return
	
	# The item sets a condition to be pickable
	# a timer of 0.2 second is the default, to prevent it to be pickable right 
	# after the player drops it
	pickable = pickable_condition(delta)
	
	if stuck:
		return
	
	# If the velocity is grater than the treshhold, 
	# the rotation is set to the velocity angle
	# (the treshold exists to prevent it from rotating like crazy, 
	# the velocity never gets to zero apparently)
	
		
	rotation = lerp_angle(rotation, velocity.angle(), 0.9)
	
	
	# If its on water, the velocity gradually decreases
	if in_water:
		water_physics(delta)
	# Else, it justs runs the normal gravity
	else:
		velocity.y += gravity * delta
	
	move_and_slide()

func pickable_condition(_delta: float) -> bool:
	if stuck:
		return true
	print(velocity.length())
	if velocity.length() < 50:
		return true
	return false


func _on_damage_body_entered(body: Node2D) -> void:
	if stuck or ("health" in body and body.health <= 0) or (picked and !("health" in body)):
		return
	velocity = Vector2.ZERO
	print(velocity)
	stuck = true
	
	call_deferred("reparent", body)
	
	if "health" in body and body.health > 0:
		body.health -= 1
		position += body.velocity * body.get_physics_process_delta_time()
		body.speed -= body.speed/3
		if body.health <= 0:
			picked = true
			pickable = false
			for node: Node in body.get_children():
				if node is Item:
					node.picked = true
					node.pickable = false
		else:
			picked = false
	
	
