extends Panel

var isIn : bool

func _ready() -> void:
	GameManager.hudOptions = self
	$Panel/MuteTextureButton.pressed = GameManager.audioBool
	var _error : int = $Panel/MuteTextureButton.connect("toggled", self, "_on_MuteTextureButton_toggled")

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			get_tree().set_pause(false)
			#$PauseTextureButton.visible = true
			$Panel.visible = false

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
	get_tree().set_pause(!get_tree().is_paused())
	#$PauseTextureButton.visible = false
	$Panel.visible = !$Panel.visible
	MusicController.ButtonSound()

func Pause() -> void:
	get_tree().set_pause(!get_tree().is_paused())
	$Panel.visible = !$Panel.visible

func _on_Panel_mouse_exited() -> void:
	isIn = false
	MusicController.ButtonSound()


func _on_Panel_mouse_entered() -> void:
	isIn = true
	MusicController.ButtonSound()


func _on_Sair_pressed() -> void:
	var _error : int = get_tree().change_scene("res://Assets/Scenes/Menu.tscn")
	MusicController.ChangeMusic(MusicController.MusicsNumber.Menu)
	MusicController.ButtonSound()


func _on_Sim_pressed() -> void:
	MusicController.PlaySound()
	MusicController.current.stop()
	MusicController.next.stop()
	GameManager.targetScene = "res://Assets/Scenes/Mundo.tscn"
	var _error : int = get_tree().change_scene("res://Assets/Scenes/Loading.tscn")
	#MusicController.ChangeMusic(MusicController.MusicsNumber.Ceara)
