extends Item
class_name Fish

@onready var area2D: Area2D = $Area2D
@onready var player_inventory: Array[InventoryItem] = get_tree().get_first_node_in_group("Player").get_node("InventoryManager").Inventory
@onready var player: Player = get_tree().get_first_node_in_group("Player")
var player_in_view: bool = false


@export var SPEED: float = 50
@export var health: int = 1:
	set(new_value):
		health = new_value
		got_hurt.emit()

signal got_hurt

@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	area2D.connect("body_entered", body_entered)
	area2D.connect("body_exited", body_exited)

func body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_view = true

func body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_view = false

func pickable_condition(delta: float) -> bool:
	if timer <= 0:
		if state_machine.current_state.name == "Dead":
			return true
	else:
		timer -= delta
	return false

func _physics_process(delta: float) -> void:
	if !picked and state_machine.current_state.name == "Dead":
		unpicked_item_physics(delta)

func action() -> void:
	var self_reference: InventoryItem = null
	for item: InventoryItem in player_inventory:
		if item.item_name.to_upper() == display_name.to_upper():
			self_reference = item
			continue
	
	self_reference.quantity -= 1
	if self_reference.quantity <= 0:
		player_inventory.erase(self_reference)
		player.get_node("CurrentItemManager").decrease_item_index()
	print("comeu")
