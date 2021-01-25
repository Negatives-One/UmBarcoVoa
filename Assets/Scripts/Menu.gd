extends Control

class_name Menu

var loadScene : String = "res://Assets/Scenes/Loading.tscn"


func _ready() -> void:
	$Panel/MuteUnmute.pressed = GameManager.readData("mute", false)
	var _error : int = $Panel/MuteUnmute.connect("toggled", self, "_on_MuteUnmute_toggled")
	MusicController.menu = self

func _on_MuteUnmute_toggled(button_pressed: bool) -> void:
	GameManager.saveData({"mute" : button_pressed})
	GameManager.onlySaveData(true)
	MusicController.ButtonSound()
	AudioServer.set_bus_mute(0, GameManager.readData("mute", false))


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
