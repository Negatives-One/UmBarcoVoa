extends RigidBody2D

var tempo : float = 0.0

var tempo2 : float = 0.0

func _ready() -> void:
	linear_velocity.x = $"..".speed

func _process(delta: float) -> void:
	tempo += delta
	$"../Label".text = str(tempo)
	$"../Label3".text = str(global_position.x - 200)

func _physics_process(delta: float) -> void:
	linear_velocity.x = $"..".speed
	tempo2 += delta
	$"../Label2".text = str(tempo2)

func _on_Timer_timeout() -> void:
	linear_velocity.x = 0
	set_process(false)
	set_physics_process(false)
