extends Control

class_name Menu

var loadScene : String = "res://Assets/Scenes/Loading.tscn"


func _ready() -> void:
	$Panel/MuteUnmute.pressed = GameManager.readData("mute", false)
	$Credits/MuteUnmuteCredits.pressed = GameManager.readData("mute", false)
	var _error : int = $Panel/MuteUnmute.connect("toggled", self, "_on_MuteUnmute_toggled")
	var _error2 : int = $Credits/MuteUnmuteCredits.connect("toggled", self, "_on_MuteUnmuteCredits_toggled")
	MusicController.menu = self

func _on_MuteUnmute_toggled(button_pressed: bool) -> void:
	GameManager.saveData({"mute" : button_pressed})
	GameManager.onlySaveData(true)
	MusicController.ButtonSound()
	AudioServer.set_bus_mute(0, GameManager.readData("mute", false))
	$Panel/MuteUnmute.pressed = GameManager.readData("mute", false)
	$Credits/MuteUnmuteCredits.pressed = GameManager.readData("mute", false)


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


func _on_DoeTextureButton_pressed():
	MusicController.ButtonSound()
	$Confirmation.visible = true


func _on_OK_pressed():
	MusicController.ButtonSound()
	OS.shell_open("http://www.depresenteofuturo.com.br/")
	$Confirmation.visible = false


func _on_Voltar_pressed():
	MusicController.ButtonSound()
	$Confirmation.visible = false


func _on_CreditosTextureButton_pressed():
	MusicController.ButtonSound()
	$Panel.visible = false
	$TextureRect.visible = false
	$Credits.visible = true
	$Credits/AnimationPlayer.play("creditos")
	


func _on_VoltarTextureButton_pressed():
	MusicController.ButtonSound()
	$Panel.visible = true
	$TextureRect.visible = true
	$Credits.visible = false
	$Credits/AnimationPlayer.stop()


func _on_MuteUnmuteCredits_toggled(button_pressed):
	GameManager.saveData({"mute" : button_pressed})
	GameManager.onlySaveData(true)
	MusicController.ButtonSound()
	AudioServer.set_bus_mute(0, GameManager.readData("mute", false))
	$Panel/MuteUnmute.pressed = GameManager.readData("mute", false)
	$Credits/MuteUnmuteCredits.pressed = GameManager.readData("mute", false)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "creditos":
		$Panel.visible = true
		$TextureRect.visible = true
		$Credits.visible = false
		$Credits/AnimationPlayer.stop()
