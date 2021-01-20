extends Panel


func _ready() -> void:
	$Panel/MuteTextureButton.pressed = GameManager.audioBool
	$Panel/MuteTextureButton.connect("toggled", self, "_on_MuteTextureButton_toggled")


func _on_ResumePause_pressed() -> void:
	get_tree().set_pause(false)
	$PauseTextureButton.visible = true
	$Panel.visible = false
	MusicController.ButtonSound()


func _on_MenuTextureButton_pressed() -> void:
	MusicController.ButtonSound()
	MusicController.ChangeMusic(MusicController.MusicsNumber.Menu)
	get_tree().set_pause(false)
	GameManager.targetScene = "res://Assets/Scenes/Menu.tscn"
	var _error : int = get_tree().change_scene("res://Assets/Scenes/Menu.tscn")#"res://Assets/Scenes/Loading.tscn")


func _on_RecomecarTextureButton_pressed() -> void:
	MusicController.ButtonSound()
	pass # Replace with function body.


func _on_MuteTextureButton_toggled(button_pressed: bool) -> void:
	GameManager.audioBool = button_pressed
	GameManager.saveSettings()
	AudioServer.set_bus_mute(0, GameManager.audioBool)
	MusicController.ButtonSound()


func _on_PauseTextureButton_pressed() -> void:
	get_tree().set_pause(true)
	$PauseTextureButton.visible = false
	$Panel.visible = true
	MusicController.ButtonSound()
