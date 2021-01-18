extends Panel


func _ready() -> void:
	$Panel/MuteTextureButton.pressed = GameManager.audioBool


func _on_ResumePause_pressed() -> void:
	get_tree().set_pause(false)
	$PauseTextureButton.visible = true
	$Panel.visible = false


func _on_MenuTextureButton_pressed() -> void:
	MusicController.ChangeMusic(MusicController.MusicsNumber.Menu)
	get_tree().set_pause(false)
	var _error : int = get_tree().change_scene("res://Assets/Scenes/Menu.tscn")


func _on_RecomecarTextureButton_pressed() -> void:
	pass # Replace with function body.


func _on_MuteTextureButton_toggled(button_pressed: bool) -> void:
	GameManager.audioBool = button_pressed
	GameManager.saveSettings()
	AudioServer.set_bus_mute(0, GameManager.audioBool)


func _on_PauseTextureButton_pressed() -> void:
	get_tree().set_pause(true)
	$PauseTextureButton.visible = false
	$Panel.visible = true
