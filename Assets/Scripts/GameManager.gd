extends Node

var saveVars : Array = ["AudioBool", "highScore"]
export(Script) var gameSave : Script

var audioBool : bool = true

var targetScene : String

func _init() -> void:
	if not loadSettings():
		saveSettings()
	UpdateMute()

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)

func _notification(what: int) -> void:
	#WINDOWS
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()
	#ANDROID
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		pass

func verifySave(saveResource) -> bool:
	for v in saveVars:
		if saveResource.get(v) == null:
			return false
	return true

func saveSettings() -> void:
	var saveSystem : SaveSystem = gameSave.new()
	saveSystem.AudioBool = audioBool
	var dir : Directory = Directory.new()
	if not dir.dir_exists("res://Saves/"):
		var _error : int = dir.make_dir_recursive("res://Saves/")
	var _error : int = ResourceSaver.save("res://Saves/Save.tres", saveSystem)

func loadSettings() -> bool:
	var dir : Directory = Directory.new()
	if not dir.file_exists("res://Saves/Save.tres"):
		return false
	
	var saveResource = load("res://Saves/Save.tres")
	if not verifySave(saveResource):
		return false
	audioBool = saveResource.AudioBool
	return true

func UpdateMute() -> void:
	AudioServer.set_bus_mute(0, audioBool)
