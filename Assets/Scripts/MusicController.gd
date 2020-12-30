extends Node

var musicas : Array = ["aFORTALEZA_loop1.ogg", "bPARAIBA_loop1.ogg", "cPERNAMBUCO_loop1.ogg", "dBAHIA_loop1.ogg"]

var stageController : StageController

var MusicFolder : String = "res://Assets/Sounds/"

enum Locations {Fortaleza, Paraiba, Pernambuco, Bahia}

export(float) var transitionDuration : float = 4.5

enum transitions {TRANS_LINEAR, TRANS_SINE, TRANS_QUINT, TRANS_QUART, TRANS_QUAD, TRANS_EXPO, TRANS_ELASTIC, TRANS_CUBIC, TRANS_CIRC, TRANS_BOUNCE, TRANS_BACK}

enum easings {EASE_IN, EASE_OUT, EASE_IN_OUT, EASE_OUT_IN}

export(transitions) var transitionTypeFadeIn : int = Tween.TRANS_LINEAR

export(easings) var easingTypeFadeIn : int = Tween.EASE_IN

export(transitions) var transitionTypeFadeOut : int = Tween.TRANS_LINEAR

export(easings) var easingTypeFadeOut : int = Tween.EASE_IN

func _ready() -> void:
	$Current.stream = load(MusicFolder + musicas[Locations.Fortaleza])
	$Current.play()
	$Next.stream = load(MusicFolder + musicas[Locations.Paraiba])

#func GetFiles(path) -> Array:
#	var files : Array = []
#	var dir : Directory = Directory.new()
#	var _openError = dir.open(path)
#	var _dirError = dir.list_dir_begin(true)
#	var file : String = dir.get_next()
#	while file != '':
#		if file[file.length() -1 ] == 'g':
#			files += [file]
#		else:
#			pass
#		file = dir.get_next()
#	return files

func ChangeMusic() -> void:
	var locationNumber = stageController.currentLocation
	if locationNumber == 3:
		locationNumber = -1
	if $Current.playing:
		fadeOut($Current, $TweenCurrent)
		$Next.stream = load(MusicFolder + musicas[locationNumber + 1])
		fadeIn($Next, $TweenNext)
	else:
		fadeOut($Next, $TweenNext)
		$Current.stream = load(MusicFolder + musicas[locationNumber + 1])
		fadeIn($Current, $TweenCurrent)

func fadeOut(streamPlayer : AudioStreamPlayer, tween : Tween):
	var _interpolateBool : bool = tween.interpolate_property(streamPlayer, "volume_db", 0, -80, transitionDuration, transitionTypeFadeOut, easingTypeFadeOut, 0)
	var _startBool : bool = tween.start()

func fadeIn(streamPlayer : AudioStreamPlayer, tween : Tween):
	streamPlayer.play()
	var _interpolateBool : bool = tween.interpolate_property(streamPlayer, "volume_db", -80, 0, transitionDuration, transitionTypeFadeIn, easingTypeFadeIn, 0)
	var _startBool : bool = tween.start()

func _on_TweenCurrent_tween_completed(_object: Object, _key: NodePath) -> void:
	if $Current.volume_db < -79:
		$Current.playing = false

func _on_TweenNext_tween_completed(_object: Object, _key: NodePath) -> void:
	if $Next.volume_db < -79:
		$Next.playing = false
