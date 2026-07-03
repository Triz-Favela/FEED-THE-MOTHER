extends Node2D

@onready var Inventory_menu = $"../UI/Inventory"
@onready var Inventory_items_list = $"../UI/Inventory/InventoryContents/InventoryItems/HBoxContainer/ScrollContainer/ItemsList"
@onready var Anim_tree:AnimationTree = $"../Player_visuals/AnimationTree"
@onready var Anim_state_machine = Anim_tree.get("parameters/playback")

var teste:PackedScene
var current_item:Item = null
var current_item_reference = null:
	set(new_value):
		current_item_reference = new_value
		update_current_item()

var decrease_item_index = func():
		if current_item_reference == null:
			update_current_item()
			return
		if current_item_reference.get_index() == 0:
			current_item_reference = null
		elif current_item_reference.get_index() > 0:
			current_item_reference = Inventory_items_list.get_child(current_item_reference.get_index() - 1)
var increase_item_index = func():
		if current_item_reference == null:
			current_item_reference = Inventory_items_list.get_child(0)
		elif current_item_reference.get_index() < Inventory_items_list.get_child_count() - 1:
			current_item_reference = Inventory_items_list.get_child(current_item_reference.get_index() + 1)

func _ready():
	#await get_tree().process_frame
	update_current_item()

func _physics_process(_delta):
	var mouse_angle = get_parent().get_angle_to(get_global_mouse_position())
	var flipped = 1
	if mouse_angle > -1.5 and mouse_angle < 1.5:
		flipped = 1
	else:
		flipped = -1
	
	if current_item != null:
		current_item.scale.y = flipped
	
	global_position = $"../Player_visuals/Skeleton2D/root/UpperBody/H_Arm/Marker2D".global_position
	rotation = mouse_angle
	$"../Player_visuals/Skeleton2D/root/UpperBody/H_Arm".rotation = (mouse_angle + deg_to_rad(90 * flipped)) * -flipped + deg_to_rad(90 * flipped)


func _process(_delta):
	if Input.is_action_just_pressed("SHOW_HIDE_INV"):
		Inventory_menu.visible = !Inventory_menu.visible
		#if Inventory_menu.visible:
			#Inventory_menu.visible = false
		#else:
			#Inventory_menu.visible = true
	
	if Inventory_menu.visible:
		return
	
	if Input.is_action_just_pressed("INV_DOWN"):
		increase_item_index.call()
	if Input.is_action_just_pressed("INV_UP"):
		decrease_item_index.call()
	
	if Input.is_action_just_pressed("ITEM_ACTION") and is_instance_valid(current_item):
		current_item.action()
	if Input.is_action_just_pressed("THROW_ITEM") and is_instance_valid(current_item):
		throw_current_item()
	

func update_current_item():
	
	#delete current item from hand
	if get_child_count() > 0:
		get_child(0).queue_free()
	
	#if the index is not -1 (free hand index)
	if current_item_reference != null and Inventory_items_list.get_child_count() > 0:
		var instance = current_item_reference.item_value.instantiate()
		instance.picked = true
		instance.pickable = false
		call_deferred("add_child", instance)
		current_item = instance
		await child_order_changed
	else:
		current_item = null
	
	await get_tree().process_frame
	
	if get_child_count() > 0:
		$"../Player_visuals/Polygons/F_Arm".visible = false
		$"../Player_visuals/Polygons/H_Arm".visible = true
	else:
		$"../Player_visuals/Polygons/F_Arm".visible = true
		$"../Player_visuals/Polygons/H_Arm".visible = false

func throw_current_item(just_drop_it: bool = false):
	var thrown_item = current_item
	thrown_item.call_deferred("reparent",get_tree().current_scene)
	thrown_item.picked = false
	await child_order_changed
	current_item_reference.item_qntt -= 1
	if current_item_reference.item_qntt <=0:
		current_item_reference.queue_free()
		decrease_item_index.call()
	else:
		update_current_item()
	
	if thrown_item is Fish:
		thrown_item.health = 0
	if !just_drop_it:
		thrown_item.velocity = ((get_global_mouse_position() - global_position).normalized() * 500) + get_parent().velocity/2
