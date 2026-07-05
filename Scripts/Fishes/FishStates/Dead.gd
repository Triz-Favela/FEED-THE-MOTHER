extends FishState

func enter() -> void:
	print(self_fish.state_machine.current_state.name)
