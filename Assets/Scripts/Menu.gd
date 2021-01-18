extends Control

class_name Menu

var go : bool = false

var loading : ResourceInteractiveLoader

func _ready() -> void:
	$Panel/MuteUnmute.pressed = GameManager.audioBool
	MusicController.menu = self

func _process(_delta: float) -> void:
	if $Loading.visible:
		var _error : int = loading.poll()
		$Loading/ProgressBar.value = loading.get_stage()
		if loading.get_resource() != null and go == true:
			$Loading/ProgressBar.value = $Loading/ProgressBar.max_value
			var _changeError : int = get_tree().change_scene_to(loading.get_resource())
			#var mundo = loading.get_resource().instance()
			#$"/root".add_child(mundo)
			MusicController.ChangeMusic(MusicController.MusicsNumber.Ceara)
			MusicController.get_node("Current").volume_db = -80
			MusicController.get_node("Next").volume_db = -80
			set_process(false)

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
	AudioServer.set_bus_mute(0, GameManager.audioBool)


func _on_PlayTextureButton_pressed() -> void:
	MusicController.PlaySound()
	MusicController.MenuGameTransition()
	loading = ResourceLoader.load_interactive("res://Assets/Scenes/Mundo.tscn")
	$Loading/ProgressBar.max_value = loading.get_stage_count()
	$Loading.visible = true

func _on_SairTextureButton_pressed() -> void:
	get_tree().quit()
