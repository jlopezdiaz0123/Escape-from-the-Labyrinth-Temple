extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(_delta):
	pass
func _on_boton_volver_pressed():
	get_tree().change_scene_to_file("res://Pantallas/menuInicio.tscn")