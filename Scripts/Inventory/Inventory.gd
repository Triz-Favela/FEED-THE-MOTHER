extends PanelContainer

@export var inventory:Array[InventoryItem] = []

@onready var scroll_bar = $InventoryContents/InventoryItems/HBoxContainer/VScrollBar
@onready var scroll_container = $InventoryContents/InventoryItems/HBoxContainer/ScrollContainer
@onready var items_list = $InventoryContents/InventoryItems/HBoxContainer/ScrollContainer/ItemsList
@onready var player_current_item = $"../../CurrentItem"
@onready var weight_label = $InventoryContents/HBoxContainer2/PanelContainer2/HBoxContainer/Label2

var item_template = preload("res://Scenes/Inventory/inventoryItem.tscn")
var scrolling: bool = false
var total_weight: int = 0:
	set(new_value):
		total_weight = new_value
		get_tree().get_first_node_in_group("Player").update_velocity(new_value)


func _ready():
	adjust_scroll_bar()
func adjust_scroll_bar():
	scroll_bar.max_value = items_list.get_child_count() * 48
	scroll_bar.page = 399

func _process(_delta):
	if scrolling:
		scrolling = false
		return
	scroll_bar.value = scroll_container.scroll_vertical

func _on_v_scroll_bar_scrolling():
	scrolling = true
	scroll_container.scroll_vertical = scroll_bar.value

func add_to_item_list(item):
	for node in items_list.get_children():
		if item.display_name == node.item_name:
			node.item_qntt += 1
			return
	var instance = item_template.instantiate()
	instance.item_value = load(item.scene_file_path)
	instance.item_name = item.display_name
	instance.item_weight = item.weight
	if item.get_node("Sprite2D"):
		instance.item_image = item.get_node("Sprite2D").texture
	items_list.add_child(instance)

func _on_catch_item_body_entered(body):
	if body is Item and body.pickable:
		add_to_item_list(body)
		for node in body.get_children():
			if node is Item:
				add_to_item_list(node)
		body.queue_free()


func _on_child_entered_tree(node):
	total_weight += node.item_weight
	weight_label.text = str(total_weight)
	adjust_scroll_bar()


func _on_child_exiting_tree(node):
	total_weight  -= node.item_weight
	weight_label.text = str(total_weight)
	adjust_scroll_bar()
