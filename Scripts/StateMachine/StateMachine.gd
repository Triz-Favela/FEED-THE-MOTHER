extends Node
class_name StateMachine

@export var initial_state: State

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

var current_state: State

func _ready() -> void:
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
	current_state = new_state
	current_state.enter()
