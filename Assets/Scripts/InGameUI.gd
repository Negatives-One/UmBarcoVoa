extends Panel

var isIn : bool

var recomecar : bool = false

var loadScene

func _ready() -> void:
	GameManager.hudOptions = self
	$Panel/MuteTextureButton.pressed = GameManager.readData("mute", false)
	var _error : int = $Panel/MuteTextureButton.connect("toggled", self, "_on_MuteTextureButton_toggled")

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			get_tree().set_pause(false)
			#$PauseTextureButton.visible = true
			$Panel.visible = false

func _on_MenuTextureButton_pressed() -> void:
	MusicController.ButtonSound()
	get_tree().set_pause(false)
	var loading : Loading = load("res://Assets/Scenes/Loading.tscn").instance()
	loading.SetTargetScene("res://Assets/Scenes/Menu.tscn", true)
	$PanelTween.interpolate_property(loading, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$PanelTween.start()
	self.add_child(loading)

func _on_RecomecarTextureButton_pressed() -> void:
	recomecar = true
	MusicController.ButtonSound()
	if MusicController.get_node("Current").playing:
		MusicController.fadeOut(MusicController.get_node("Current"), $PanelTween)#MusicController.get_node("TweenCurrent"))
	else:
		MusicController.fadeOut(MusicController.get_node("Next"), $PanelTween)#MusicController.get_node("TweenNext"))
	#MusicController.ChangeMusic(MusicController.MusicsNumber.Ceara)
	var loading : Loading = load("res://Assets/Scenes/Loading.tscn").instance()
	loadScene = loading
	loading.SetTargetScene("res://Assets/Scenes/Mundo.tscn", false)
	$PanelTween.interpolate_property(loading, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$PanelTween.start()
	self.add_child(loading)

func _on_MuteTextureButton_toggled(button_pressed: bool) -> void:
	GameManager.saveData({"mute" : button_pressed})
	GameManager.onlySaveData(true)
	MusicController.ButtonSound()
	AudioServer.set_bus_mute(0, GameManager.readData("mute", false))


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
#	var _error : int = get_tree().change_scene("res://Assets/Scenes/Menu.tscn")
#	MusicController.ChangeMusic(MusicController.MusicsNumber.Menu)
#	MusicController.ButtonSound()
	MusicController.ButtonSound()
	var loading : Loading = load("res://Assets/Scenes/Loading.tscn").instance()
	loading.SetTargetScene("res://Assets/Scenes/Menu.tscn", true)
	$PanelTween.interpolate_property(loading, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$PanelTween.start()
	self.add_child(loading)

func _on_Sim_pressed() -> void:
	MusicController.PlaySound()
	var loading : Loading = load("res://Assets/Scenes/Loading.tscn").instance()
	loading.SetTargetScene("res://Assets/Scenes/Mundo.tscn", false)
	$PanelTween.interpolate_property(loading, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$PanelTween.start()
	self.add_child(loading)


func _on_PanelTween_tween_completed(object: Object, _key: NodePath) -> void:
	if object == MusicController.get_node("Current") and recomecar:
		loadScene.go = true
		get_tree().set_pause(false)
