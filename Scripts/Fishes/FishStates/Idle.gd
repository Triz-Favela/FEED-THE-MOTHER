extends FishState

var PlayerInView: bool = false
var FleeTimer: float = 3

@export var Flee: FishState

func enter() -> void:
	
	PlayerDetector.connect("body_entered", player_entered)
	PlayerDetector.connect("body_exited", player_exited)

func process_frame(_delta: float) -> void:
	pass

func process_physics(_delta: float) -> State:
	if PlayerInView:
		return Flee
	return null

func player_entered(body: Node2D) -> void:
	if body is Player:
		PlayerInView = true

func player_exited(body: Node2D) -> void:
	if body is Player:
		PlayerInView = false


func exit() -> void:
	PlayerDetector.disconnect("body_entered", player_entered)
	PlayerDetector.disconnect("body_exited", player_exited)
