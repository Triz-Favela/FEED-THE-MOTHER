extends Node
class_name InventoryManager

@export var Inventory: Array[InventoryItem] = []

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Item and body.pickable:
		# It checks to see if the body has any item as its child
		# (to check if the spear is in it, but i think i can do some cool thiungs with it too)
		for child: Node in body.get_children():
			if child is Item:
				child.pickable = true
				_on_area_2d_body_entered(child)
		
		# If theres a item of the same type in the Inventory, 
		# it adds 1 to the quantity count and returns the function
		for item: InventoryItem in Inventory:
			if item.item_name.to_upper() == body.display_name.to_upper():
				item.quantity += 1
				body.queue_free()
				return
		
		# Else, it creates a new InventoryItem to it, and stores it in the Inventory array
		var new_item: InventoryItem = InventoryItem.new()
		new_item.item_name = body.display_name
		new_item.scene = load(body.scene_file_path)
		Inventory.push_back(new_item)
		
		
		body.queue_free()
