extends KinematicBody2D

var acel : Vector2 = Vector2.ZERO
var vel : Vector2 = Vector2.ZERO
export var mass : float = 0

func _physics_process(delta) -> void:
	if Input.is_action_pressed("LClick"):
		acel += Vector2(1, 0)
		acel += Seek()
		acel = acel.normalized()
	vel += acel
	vel.clamped(10)
	move_and_slide(vel)
	acel = Vector2.ZERO
	if Input.is_action_just_pressed("ui_left"):
		vel = vel/2

func Seek() -> Vector2:
	var mousePos : Vector2 = Vector2(0, get_global_mouse_position().y)
	var selfPos : Vector2 = Vector2(0, self.global_position.y)
	var direction : Vector2 = (mousePos - selfPos).normalized()
	return direction

func AddForce(dir : Vector2) -> void:
	acel += dir

func _draw():
	draw_line(global_position, global_position + vel, Color.red)
