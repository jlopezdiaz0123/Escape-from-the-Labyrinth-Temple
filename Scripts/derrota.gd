extends Control
@export var boo_path : String = "res://Sonido/boo.wav"
var boo : AudioStreamPlayer

func _ready():
	boo = AudioStreamPlayer.new()
	boo.stream = load(boo_path)
	add_child(boo)
	if not boo.playing:
		boo.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(_delta):
	pass

func _on_boton_volver_pressed():
	get_tree().change_scene_to_file("res://Pantallas/menuInicio.tscn")