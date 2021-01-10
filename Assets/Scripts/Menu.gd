extends Control

var loading : ResourceInteractiveLoader

func _process(_delta: float) -> void:
	if $Loading.visible:
		var _error : int = loading.poll()
		$Loading/ProgressBar.value = loading.get_stage()
		if loading.get_resource() != null:
			$Loading/ProgressBar.value = $Loading/ProgressBar.max_value
			var _changeError : int = get_tree().change_scene_to(loading.get_resource())

func _on_PlayButton_pressed() -> void:
	loading = ResourceLoader.load_interactive("res://Assets/Scenes/Mundo.tscn")
	$Loading/ProgressBar.max_value = loading.get_stage_count()
	$Loading.visible = true
	#var _error : int = get_tree().change_scene("res://Assets/Scenes/Mundo.tscn")


func _on_OptionsButton_pressed() -> void:
	$"OptionsPanel/ColorRect3/HSlider".value = db2linear(GameManager.soundMaster)
	print(db2linear(GameManager.soundMaster))
	$OptionsPanel.visible = true


func _on_ApplyOptions_pressed() -> void:
	$OptionsPanel.visible = false
	GameManager.saveSettings()


func _on_HSlider_value_changed(_value: float) -> void:
	GameManager.SetVolume(linear2db($"OptionsPanel/ColorRect3/HSlider".value))
