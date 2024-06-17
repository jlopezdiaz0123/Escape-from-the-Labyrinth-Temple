extends Control

func _ready():
	pass

func _on_boton_jugar_pressed():
	if Global.con_tiempo == true:
		ControlJuego.start_timer()
	var escena_a_cargar = ""
	match Global.dificultad:
		"normal":
			escena_a_cargar = "res://Niveles/laberintoNormal.tscn"
		"dificil":
			escena_a_cargar = "res://Niveles/laberintoDificil.tscn"

	if escena_a_cargar != "":
		get_tree().change_scene_to_file(escena_a_cargar)

func _on_boton_opciones_pressed():
	get_tree().change_scene_to_file("res://Pantallas/opciones.tscn")

func _on_boton_instrucciones_pressed():
	get_tree().change_scene_to_file("res://Pantallas/comoJugar.tscn")

func _on_boton_salir_pressed():
	get_tree().quit()