extends Control

class_name Loading

var loading : ResourceInteractiveLoader

var targetScene : String

var go : bool = true

func _ready() -> void:
	$AnimationPlayerSol.play("AnimacaoSol")
	$AnimationPlayerTexto.play("TextAnim")
	MusicController.loadingScene = self

func _process(_delta: float) -> void:
	var _error : int = loading.poll()
	if loading.get_resource() != null and go == true:
		var _changeError : int = get_tree().change_scene_to(loading.get_resource())
		#var mundo = loading.get_resource().instance()
		#$"/root".add_child(mundo)
		if targetScene == "res://Assets/Scenes/Mundo.tscn":
			MusicController.ChangeMusic(MusicController.MusicsNumber.Ceara)
			MusicController.get_node("Current").volume_db = -80
			MusicController.get_node("Next").volume_db = -80
		else:
			MusicController.ChangeMusic(MusicController.MusicsNumber.Menu)
		set_process(false)

func SetTargetScene(cenaAlvo : String, x : bool = false) -> void:
	targetScene = cenaAlvo
	go = x
	loading = ResourceLoader.load_interactive(targetScene)
	set_process(true)
