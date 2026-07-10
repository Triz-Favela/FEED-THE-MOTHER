extends Item
class_name Harpoon

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var player_inventory: Array[InventoryItem] = player.get_node("InventoryManager").Inventory
var cooldown: float = 0

func _process(delta: float) -> void:
	if cooldown > 0:
		cooldown -= delta

func action() -> void:
	if cooldown > 0:
		print("esfriando")
		return
	
	var spear: InventoryItem = null
	for item: InventoryItem in player_inventory:
		if item.item_name.to_upper() == "SPEAR":
			spear = item
			continue
	
	if spear == null:
		return
	
	cooldown = 0.35
	player.make_noise.emit()
	
	var instance: Item = spear.scene.instantiate()
	instance.global_position = $Marker2D.global_position
	instance.velocity = (get_global_mouse_position() - global_position).normalized() * 900
	instance.rotation = instance.velocity.angle()
	
	get_tree().current_scene.call_deferred("add_child", instance)
	await instance.tree_entered

	spear.quantity -= 1
	if spear.quantity <=0:
		player_inventory.erase(spear)
