extends Node2D
class_name CurrentItemManager

@export var inventory_manager: InventoryManager
@onready var inventory: Array[InventoryItem] = inventory_manager.Inventory

@export var arm: Bone2D
@export var arm_position_marker: Marker2D

var current_item:Item = null
var current_item_index: int = -1
var switching_item: bool = false

enum {
	EMPTY = -1
}

func _physics_process(_delta: float) -> void:
	var mouse_angle: float = get_parent().get_angle_to(get_global_mouse_position())
	var flipped: int = 1
	if mouse_angle > -1.5 and mouse_angle < 1.5:
		flipped = 1
	else:
		flipped = -1
	
	if current_item != null:
		current_item.scale.y = flipped
	
	global_position = arm_position_marker.global_position
	rotation = mouse_angle
	arm.rotation = (mouse_angle + deg_to_rad(90 * flipped)) * -flipped + deg_to_rad(90 * flipped)

func _input(event: InputEvent) -> void:
	#if event.is_action("SHOW_HIDE_INV"):
		#Inventory_menu.visible = !Inventory_menu.visible
	#
	#if Inventory_menu.visible:
		#return
	
	#TODO: Maybe change the switching_item check, but it works for now
	# Check the switching_item variable, that switching isnt instataneous
	# so it discards that input if the item is switching
	if !event.is_pressed() or switching_item:
		return
	
	if event.is_action("INV_DOWN"):
		increase_item_index()
	if event.is_action("INV_UP"):
		decrease_item_index()
	
	if Input.is_action_just_pressed("ITEM_ACTION") and is_instance_valid(current_item):
		current_item.action()
	if Input.is_action_just_pressed("THROW_ITEM") and is_instance_valid(current_item):
		throw_current_item()

func decrease_item_index() -> void:
	# If the inventory is empty, then the current_item_index is set to -1 (EMPTY) 
	if inventory.size() <= 0:
		current_item_index = EMPTY
		update_current_item()
		return
	
	# It checks the target_index, if its lesser than -1 (EMPTY), it loops the Inventory array
	var target_index: int = current_item_index - 1
	if target_index < -1:
		current_item_index = inventory.size() - 1
	else:
		current_item_index = target_index
	
	
	# Calls the update_current_item function
	update_current_item()
	
func increase_item_index() -> void:
	# If the inventory is empty, then the current_item_index is set to -1 (EMPTY) 
	if inventory.size() <= 0:
		current_item_index = EMPTY
		update_current_item()
		return
	
	# It checks the target_index, if its greater than the Inventory size
	# it sets the current_item_index to -1 (EMPTY)
	var target_index: int = current_item_index + 1
	if target_index >= inventory.size():
		current_item_index = EMPTY
	else:
		current_item_index = target_index
	
	# Calls the update_current_item function
	update_current_item()


func update_current_item() -> void:
	#delete current item from hand if it exists
	if get_child_count() > 0:
		get_child(0).queue_free()
	
	
	# If the current_item_index is not -1 (EMPTY) and inventory is not also empty
	# it instances the new item
	if current_item_index != -1 and inventory.size() > 0:
		var instance: Item = inventory[current_item_index].scene.instantiate()
		instance.picked = true
		instance.pickable = false
		if instance is Fish:
			instance.health = 0
		current_item = instance
		call_deferred("add_child", instance)
		
		switching_item = true
		await child_order_changed
		switching_item = false
	# Else, it just sets the curent_item to null
	else:
		current_item = null
	
	# If the current_item_index is greater than -1 (EMPTY)
	# it hides the animated arm and shows the holding one
	if current_item_index > -1:
		$"../Player_visuals/Polygons/F_Arm".visible = false
		$"../Player_visuals/Polygons/H_Arm".visible = true
	else:
		$"../Player_visuals/Polygons/F_Arm".visible = true
		$"../Player_visuals/Polygons/H_Arm".visible = false

func throw_current_item(_just_drop_it: bool = false) -> void:
	if !current_item:
		return
	
	var thrown_item: Item = current_item
	thrown_item.picked = false
	#thrown_item.velocity = ((get_global_mouse_position() - global_position).normalized() * 500)
	#thrown_item = (thrown_item.global_transform.x * 500)
	thrown_item.call_deferred("reparent",get_tree().current_scene)
	switching_item = true
	await child_order_changed
	switching_item = false
	var item_final_velocity: Vector2 = ((get_global_mouse_position() - global_position).normalized() * 500)
	if item_final_velocity.dot(get_parent().velocity) > 0:
		item_final_velocity += get_parent().velocity
	thrown_item.velocity = item_final_velocity
	
	inventory[current_item_index].quantity -= 1
	if inventory[current_item_index].quantity <=0:
		inventory.pop_at(current_item_index)
		decrease_item_index()
	else:
		update_current_item()
	
	if thrown_item is Fish:
		thrown_item.health = 0
		
