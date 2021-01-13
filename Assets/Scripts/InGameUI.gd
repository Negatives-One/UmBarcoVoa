extends Panel


func _ready() -> void:
	pass


func _on_PauseButton_button_down() -> void:
	get_tree().set_pause(true)
	$PauseButton.visible = false
	$Panel.visible = true


func _on_ResumePause_pressed() -> void:
	get_tree().set_pause(false)
	$PauseButton.visible = true
	$Panel.visible = false


func _on_Quitgame_pressed() -> void:
	MusicController.ChangeMusic(MusicController.MusicsNumber.Menu)
	get_tree().set_pause(false)
	get_tree().change_scene("res://Assets/Scenes/Menu.tscn")
