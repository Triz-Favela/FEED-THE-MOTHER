extends State
class_name FishState

@onready var PlayerDetector: Area2D = $'../../Area2D'
@export var self_fish: Fish
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
