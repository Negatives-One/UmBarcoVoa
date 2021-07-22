extends Area2D

class_name Peixe

var yOffset : float = 0

var startingPos : Vector2 = Vector2.ZERO

func _ready() -> void:
	startingPos = global_position
	$AnimationPlayer.play("WaveUpDown")
	$AnimationPlayer.advance(randf() * 2.8)

func _process(delta: float) -> void:
	global_position.y = startingPos.y + yOffset

func _on_VisibilityNotifier2D_screen_exited() -> void:
	if !$AudioStreamPlayer.playing:
		queue_free()


func _on_Area2D_body_entered(_body: Node) -> void:
	$AnimationPlayer.stop()
	GameManager.StageControll.Collected()
	$AnimatedSprite.visible = false
	$AudioStreamPlayer.play()
	$CPUParticles2D.emitting = true


func SetNote(note : String) -> void:
	var path : String = "res://Assets/NotasPeixes/" + note + ".wav"
	$AudioStreamPlayer.stream = load(path)


func _on_AudioStreamPlayer_finished() -> void:
	queue_free()


