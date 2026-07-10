extends State
class_name FishState

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@export var self_fish: Fish
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
