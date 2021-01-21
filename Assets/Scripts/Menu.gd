extends Control

class_name Menu

var loadScene : String = "res://Assets/Scenes/Loading.tscn"


func _ready() -> void:
	$Panel/MuteUnmute.pressed = GameManager.audioBool
	var _error : int = $Panel/MuteUnmute.connect("toggled", self, "_on_MuteUnmute_toggled")
	MusicController.menu = self

func _on_OptionsButton_pressed() -> void:
	$"OptionsPanel/ColorRect3/HSlider".value = db2linear(GameManager.soundMaster)
	print(db2linear(GameManager.soundMaster))
	$OptionsPanel.visible = true


func _on_ApplyOptions_pressed() -> void:
	$OptionsPanel.visible = false
	GameManager.saveSettings()


func _on_HSlider_value_changed(_value: float) -> void:
	GameManager.SetVolume(linear2db($"OptionsPanel/ColorRect3/HSlider".value))


func _on_MuteUnmute_toggled(button_pressed: bool) -> void:
	GameManager.audioBool = button_pressed
	GameManager.saveSettings()
	MusicController.ButtonSound()
	AudioServer.set_bus_mute(0, GameManager.audioBool)


func _on_PlayTextureButton_pressed() -> void:
	MusicController.PlaySound()
	MusicController.MenuGameTransition()
	GameManager.targetScene = "res://Assets/Scenes/Mundo.tscn"
	var _error : int = get_tree().change_scene(loadScene)

func _on_SairTextureButton_pressed() -> void:
	MusicController.ButtonSound()
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().quit()
