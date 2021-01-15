extends Node

var musicas : Array = ["res://Assets/Sounds/CearaLoop.ogg", "res://Assets/Sounds/PernambucoLoop.ogg", "res://Assets/Sounds/BahiaLoop.ogg", "res://Assets/Sounds/MainMenuLoop.ogg"]

var stageController : StageController

onready var ambienciaMar : AudioStreamPlayer = $AmbienciaMar

var menu : Menu

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
	$Next.stream = load(musicas[MusicsNumber.Ceara])

func MenuGameTransition() -> void:
	if $Current.playing:
		$Current.stop()
	else:
		$Next.stop()
	$TweenCurrent.interpolate_property($AmbienciaMar, "volume_db", -80, 0, transitionDuration, transitionTypeFadeIn, easingTypeFadeIn)

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

func fadeOut(streamPlayer : AudioStreamPlayer, tween : Tween):
	var _interpolateBool : bool = tween.interpolate_property(streamPlayer, "volume_db", GameManager.soundMaster, -80, transitionDuration, transitionTypeFadeOut, easingTypeFadeOut, 0)
	var _startBool : bool = tween.start()

func fadeIn(streamPlayer : AudioStreamPlayer, tween : Tween):
	streamPlayer.play()
	var _interpolateBool : bool = tween.interpolate_property(streamPlayer, "volume_db", -80, GameManager.soundMaster, transitionDuration, transitionTypeFadeIn, easingTypeFadeIn, 0)
	var _startBool : bool = tween.start()

func _on_TweenCurrent_tween_completed(_object: Object, _key: NodePath) -> void:
	if $Current.volume_db < -79:
		$Current.playing = false

func _on_TweenNext_tween_completed(_object: Object, _key: NodePath) -> void:
	if $Next.volume_db < -79:
		$Next.playing = false

func PlaySound():
	$PlaySound.play()


func _on_PlaySound_finished() -> void:
	menu.go = true
