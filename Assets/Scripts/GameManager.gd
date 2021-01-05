extends Node

var saveVars : Array = ["masterVolume", "highScore"]
export(Script) var gameSave : Script

var soundMaster : float = 0

func _init() -> void:
	if not loadSettings():
		saveSettings()
	SetVolume(soundMaster)

func verifySave(saveResource) -> bool:
	for v in saveVars:
		if saveResource.get(v) == null:
			return false
	return true

func saveSettings() -> void:
	var saveSystem : SaveSystem = gameSave.new()
	saveSystem.masterVolume = soundMaster
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
	soundMaster = saveResource.masterVolume
	return true

func SetVolume(volume : float) -> void:
	soundMaster = volume
	MusicController.get_node("Current").volume_db = soundMaster
	MusicController.get_node("Next").volume_db = soundMaster
