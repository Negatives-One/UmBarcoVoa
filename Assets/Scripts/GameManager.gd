extends Node

var soundMaster : float = 0

func _ready():
	pass

func SetVolume(volume : float) -> void:
	soundMaster = volume
	MusicController.get_node("Current").volume_db = soundMaster
	MusicController.get_node("Next").volume_db = soundMaster
