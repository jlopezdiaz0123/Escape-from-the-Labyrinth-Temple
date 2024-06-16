extends Control

var boton_normal
var boton_dificil
var boton_con_tiempo
var boton_sin_tiempo

func _ready():

	boton_normal = $BotonNormal
	boton_dificil = $BotonDificil
	boton_con_tiempo = $BotonConTiempo
	boton_sin_tiempo = $BotonSinTiempo

	restaurar_seleccion()

func _process(_delta):
	pass

func _on_boton_volver_pressed():
	get_tree().change_scene_to_file("res://Pantallas/menuInicio.tscn")

func _on_boton_normal_pressed():
	print("Opción normal seleccionada")
	Global.set_dificultad("normal")
	actualizar_botones()

func _on_boton_dificil_pressed():
	print("Opción difícil seleccionada")
	Global.set_dificultad("dificil")
	actualizar_botones()

func _on_boton_con_tiempo_pressed():
	print("Modo con tiempo seleccionado")
	Global.set_con_tiempo(true)
	Global.set_dificultad(Global.dificultad)
	actualizar_botones()

func _on_boton_sin_tiempo_2_pressed():
	print("Modo sin tiempo seleccionado")
	Global.set_con_tiempo(false)
	actualizar_botones()

func actualizar_botones():
	boton_normal.modulate = Color(1, 1, 1)
	boton_dificil.modulate = Color(1, 1, 1)
	boton_con_tiempo.modulate = Color(1, 1, 1)
	boton_sin_tiempo.modulate = Color(1, 1, 1)

	match Global.dificultad:
		"normal":
			boton_normal.modulate = Color(1, 1, 0)
		"dificil":
			boton_dificil.modulate = Color(1, 1, 0)

	if Global.con_tiempo:
		boton_con_tiempo.modulate = Color(1, 1, 0)
	else:
		boton_sin_tiempo.modulate = Color(1, 1, 0)

func restaurar_seleccion():
	actualizar_botones()