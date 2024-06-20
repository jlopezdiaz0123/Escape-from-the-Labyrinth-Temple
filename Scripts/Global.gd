extends Node

var dificultad = "normal"
var con_tiempo = true
var tiempo_inicial = 300
var con_aceleron = true
var pausa = false

func set_dificultad(new_dificultad):
	dificultad = new_dificultad
	if con_tiempo:
		if dificultad == "normal":
			tiempo_inicial = 300
		if dificultad == "dificil":
			tiempo_inicial = 3600
	print("Dificultad establecida a: " + dificultad + ", Tiempo inicial: " + str(tiempo_inicial))

func set_con_tiempo(new_con_tiempo):
	con_tiempo = new_con_tiempo
	if con_tiempo == false:
		tiempo_inicial = -1 
		
	print("Modo con tiempo: " + str(con_tiempo) + ", Tiempo inicial: " + str(tiempo_inicial))

func resetear_juego():
	print("Reseteando juego")
	ControlJuego.vidas_actuales = 3
	if ControlJuego.timer and is_instance_valid(ControlJuego.timer):
		ControlJuego.timer.queue_free()
	ControlJuego.jugador_start_position = null
	ControlJuego.malo1_start_position = null
	ControlJuego.malo2_start_position = null
	ControlJuego.malo3_start_position = null
	ControlJuego.malo4_start_position = null