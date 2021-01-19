extends Control

var loading : ResourceInteractiveLoader

var go : bool = true

func _ready() -> void:
	$AnimationPlayerSol.play("AnimacaoSol")
	$AnimationPlayerTexto.play("TextAnim")
	MusicController.loadingScene = self
	if GameManager.targetScene == "res://Assets/Scenes/Mundo.tscn":
		go = false
	loading = ResourceLoader.load_interactive(GameManager.targetScene)

func _process(_delta: float) -> void:
	var _error : int = loading.poll()
	if loading.get_resource() != null and go == true:
		var _changeError : int = get_tree().change_scene_to(loading.get_resource())
		#var mundo = loading.get_resource().instance()
		#$"/root".add_child(mundo)
		MusicController.ChangeMusic(MusicController.MusicsNumber.Ceara)
		MusicController.get_node("Current").volume_db = -80
		MusicController.get_node("Next").volume_db = -80
		set_process(false)
