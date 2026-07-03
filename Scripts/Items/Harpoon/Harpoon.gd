extends Item

@onready var player_inventory = get_tree().get_first_node_in_group("Player").get_node("CurrentItem").Inventory_items_list

func action():
	var spear = null
	for item in player_inventory.get_children():
		if item.item_name == "Spear":
			spear = item
			continue
	
	if spear == null:
		return
	
	var instance = spear.item_value.instantiate()
	get_tree().current_scene.call_deferred("add_child", instance)
	await instance.tree_entered
	instance.global_position = $Marker2D.global_position
	instance.velocity = (get_global_mouse_position() - global_position).normalized() * 900
	instance.rotation = instance.velocity.angle()

	spear.item_qntt -= 1
	if spear.item_qntt <=0:
		spear.queue_free()
	print("atirei")
