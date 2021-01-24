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

func _on_MuteUnmute_toggled(button_pressed: bool) -> void:
	GameManager.audioBool = button_pressed
	GameManager.saveSettings()
	MusicController.ButtonSound()
	AudioServer.set_bus_mute(0, GameManager.audioBool)


func _on_PlayTextureButton_pressed() -> void:
	MusicController.PlaySound()
	MusicController.MenuGameTransition()
	var loading : Loading = load(loadScene).instance()
	loading.SetTargetScene("res://Assets/Scenes/Mundo.tscn", false)
	$Tween.interpolate_property(loading, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()
	$Tween.interpolate_property($Panel, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()
	self.add_child(loading)

func _on_SairTextureButton_pressed() -> void:
	MusicController.ButtonSound()
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().quit()
