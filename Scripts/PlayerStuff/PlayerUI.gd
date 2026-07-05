extends CanvasLayer

func _process(_delta: float) -> void:
	$OxigenBar.value = $"../BreathManager".breath
	$HealthBar.value = $"..".health
