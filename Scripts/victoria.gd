extends Control

var tiempo_completado = Global.tiempo_inicial - ControlJuego.tiempo_restante

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Global.con_tiempo == true:
		var label_tiempo_completado = $LabelTiempoCompletado
		label_tiempo_completado.text = "Tiempo completado: " + str(tiempo_completado)

func _process(_delta):
	pass
func _on_boton_volver_pressed():
	get_tree().change_scene_to_file("res://Pantallas/menuInicio.tscn")