extends Control



func _on_PlayButton_pressed() -> void:
	var _error : int = get_tree().change_scene("res://Assets/Scenes/Mundo.tscn")


func _on_OptionsButton_pressed() -> void:
	$"OptionsPanel/ColorRect3/HSlider".value = db2linear(GameManager.soundMaster)
	print(db2linear(GameManager.soundMaster))
	$OptionsPanel.visible = true


func _on_ApplyOptions_pressed() -> void:
	$OptionsPanel.visible = false


func _on_HSlider_value_changed(value: float) -> void:
	GameManager.SetVolume(linear2db($"OptionsPanel/ColorRect3/HSlider".value))
