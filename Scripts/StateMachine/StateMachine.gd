extends Node
class_name StateMachine

@export var initial_state: State
@export var fallback_state: State

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

var current_state: State
var previous_state: State

func _ready() -> void:
	previous_state = fallback_state
	change_state(initial_state)

func _process(delta: float) -> void:
	var new_state: State = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

func _physics_process(delta: float) -> void:
	var new_state: State = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	previous_state = current_state
	current_state = new_state
	new_state.enter()
