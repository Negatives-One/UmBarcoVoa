extends Node

var musicas : Array = ["res://Assets/Sounds/CearaLoop.ogg", "res://Assets/Sounds/PernambucoLoop.ogg", "res://Assets/Sounds/BahiaLoop.ogg", "res://Assets/Sounds/MainMenuLoop.ogg"]

# warning-ignore:unused_class_variable
var stageController : StageController

# warning-ignore:unused_class_variable
onready var ambienciaMar : AudioStreamPlayer = $AmbienciaMar
# warning-ignore:unused_class_variable
onready var current : AudioStreamPlayer = $Current
# warning-ignore:unused_class_variable
onready var next : AudioStreamPlayer = $Next

# warning-ignore:unused_class_variable
var menu : Menu

var loadingScene

enum MusicsNumber {Ceara, Pernambuco, Bahia, Menu}

export(float) var transitionDuration : float = 2.7

enum transitions {TRANS_LINEAR, TRANS_SINE, TRANS_QUINT, TRANS_QUART, TRANS_QUAD, TRANS_EXPO, TRANS_ELASTIC, TRANS_CUBIC, TRANS_CIRC, TRANS_BOUNCE, TRANS_BACK}

enum easings {EASE_IN, EASE_OUT, EASE_IN_OUT, EASE_OUT_IN}

export(transitions) var transitionTypeFadeIn : int = Tween.TRANS_LINEAR

export(easings) var easingTypeFadeIn : int = Tween.EASE_IN

export(transitions) var transitionTypeFadeOut : int = Tween.TRANS_LINEAR

export(easings) var easingTypeFadeOut : int = Tween.EASE_IN

func _ready() -> void:
	Reset()

func Reset() -> void:
	$Current.stream = load(musicas[MusicsNumber.Menu])
	$AmbienciaMar.play()
	$Current.play()
	$Current.volume_db = 0
	$Next.stream = load(musicas[MusicsNumber.Ceara])

func MenuGameTransition() -> void:
	if $Current.playing:
		$Current.stop()
	else:
		$Next.stop()
	fadeOut($AmbienciaMar, $TweenCurrent)

func ChangeMusic(music : int) -> void:
	if $Current.playing:
		fadeOut($Current, $TweenCurrent)
		$Next.stream = load(musicas[music])
		fadeIn($Next, $TweenNext)
	else:
		fadeOut($Next, $TweenNext)
		$Current.stream = load(musicas[music])
		fadeIn($Current, $TweenCurrent)
	if music == MusicsNumber.Menu:
		$AmbienciaMar.stream = load("res://Assets/Sounds/SFX/UI/ambienciamar.ogg")
		$TweenCurrent.interpolate_property($AmbienciaMar, "volume_db", -80, 0, transitionDuration, transitionTypeFadeIn, easingTypeFadeIn)
		$AmbienciaMar.play()
	else:
		$TweenCurrent.interpolate_property($AmbienciaMar, "volume_db", 0, -80, transitionDuration, transitionTypeFadeOut, easingTypeFadeOut)

func fadeOut(streamPlayer : AudioStreamPlayer, tween : Tween) -> void:
	var _interpolateBool : bool = tween.interpolate_property(streamPlayer, "volume_db", 0, -80, transitionDuration, transitionTypeFadeOut, easingTypeFadeOut, 0)
	var _startBool : bool = tween.start()

func fadeIn(streamPlayer : AudioStreamPlayer, tween : Tween) -> void:
	streamPlayer.play()
	var _interpolateBool : bool = tween.interpolate_property(streamPlayer, "volume_db", -80, 0, transitionDuration, transitionTypeFadeIn, easingTypeFadeIn, 0)
	var _startBool : bool = tween.start()

func _on_TweenCurrent_tween_completed(_object: Object, _key: NodePath) -> void:
	if $Current.volume_db < -79:
		$Current.stop()#playing = false

func _on_TweenNext_tween_completed(_object: Object, _key: NodePath) -> void:
	if $Next.volume_db < -79:
		$Next.stop()#playing = false

func PlaySound() -> void:
	$PlaySound.play()

func LoseSound() -> void:
	$LoseSound.play()

func ButtonSound() -> void:
	$Buttons.play()

func _on_PlaySound_finished() -> void:
	loadingScene.go = true

func Mute() -> void:
	$TweenCurrent.interpolate_property($Current, "volume_db", 0, -80, transitionDuration, transitionTypeFadeOut, easingTypeFadeOut, 0)
	$TweenCurrent.start()
	$TweenNext.interpolate_property($Next, "volume_db",  0, -80, transitionDuration, transitionTypeFadeOut, easingTypeFadeOut, 0)
	$TweenNext.start()

func SimpleFadeIn() -> void:
	if $Current.playing:
		fadeOut($Current, $TweenCurrent)
		$Next.stream = load(musicas[0])
		fadeIn($Next, $TweenNext)
	else:
		fadeOut($Next, $TweenNext)
		$Current.stream = load(musicas[0])
		fadeIn($Current, $TweenCurrent)
