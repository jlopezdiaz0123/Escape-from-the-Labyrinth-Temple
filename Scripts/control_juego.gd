extends Node3D

@export var muroInvisibleSalida: StaticBody3D = null
@export var coge_llave_sound: AudioStream = null 
@export var max_vidas = 3
var vidas_actuales = max_vidas
var llave_obtenida = false
var escena_a_cargar = ""
var tiempo_restante = 0 
var timer = null
var jugador = null
var malo1 = null
var malo2 = null
var malo3 = null
var malo4 = null

var corazones = []
var label_tiempo = null
var jugador_start_position = Vector3()
var malo1_start_position = Vector3()
var malo2_start_position = Vector3()
var malo3_start_position = Vector3()
var malo4_start_position = Vector3()

func _ready():
	print("Tiempo inicial configurado: " + str(tiempo_restante))
	
	muroInvisibleSalida = find_muro_invisible_salida()

func find_muro_invisible_salida():
	var nodes = get_tree().get_nodes_in_group("MuroInvisibleSalida")
	if nodes.size() > 0:
		return nodes[0]
	else:
		return null

func initialize_scene_nodes():
	var jugadores = get_tree().get_nodes_in_group("Jugador")
	var malos = get_tree().get_nodes_in_group("Malotes")
	corazones = get_tree().get_nodes_in_group("Corazon")
	
	if jugadores.size() > 0:
		jugador = jugadores[0]
		jugador_start_position = jugador.global_position
	else:
		push_error("Jugador no encontrado en la escena.")
		return

	if malos.size() > 0:
		for malo in malos:  
			if malo.name == "Malo1":
				malo1 = malo
				malo1_start_position = malo.global_position
			elif malo.name == "Malo2":
				malo2 = malo
				malo2_start_position = malo.global_position
			elif malo.name == "Malo3":
				malo3 = malo
				malo3_start_position = malo.global_position
			elif malo.name == "Malo4":
				malo4 = malo
				malo4_start_position = malo.global_position
			if malo.has_signal("colision_con_jugador"): 
				malo.connect("colision_con_jugador", Callable(self, "_on_Area_body_entered"))

	var labels = get_tree().get_nodes_in_group("Tiempo")
	if labels.size() > 0:
		label_tiempo = labels[0]
	else:
		push_error("Label de tiempo no encontrado en la escena.")
		return

	actualizar_vidas()
	if label_tiempo:
		label_tiempo.text = "Tiempo: " + str(tiempo_restante)

	notification(NOTIFICATION_POST_ENTER_TREE)

func _notification(what):
	if what == NOTIFICATION_POST_ENTER_TREE:
		if jugador:
			jugador.connect("colision_con_malo", Callable(self, "_on_Area_body_entered"))

func actualizar_vidas():
	print("Actualizando vidas. Vidas actuales: " + str(vidas_actuales)) 
	for i in range(corazones.size()):
		if i < vidas_actuales:
			corazones[i].visible = true
		else:
			corazones[i].visible = false

func reiniciar_jugador():
	jugador.global_position = jugador_start_position
	if malo1:
		malo1.global_position = malo1_start_position
	if malo2:
		malo2.global_position = malo2_start_position
	if malo3:
		malo3.global_position = malo3_start_position
	if malo4:
		malo4.global_position = malo4_start_position

func _process(_delta):
	# No actualiazo tiempo aquí
	pass

func _on_Area_body_entered(body): 
	if body.is_in_group("Malotes") or body.is_in_group("Jugador"):  
		vidas_actuales -= 1
		actualizar_vidas()  
	
		if vidas_actuales > 0:
			reiniciar_jugador()
		else:
			
			timer.queue_free()
			mostrar_game_over()

func _on_Cofre_area_entered(cofre):
	if cofre and cofre.is_in_group("Cofre"):
		cofre.queue_free()
		mostrar_juego_ganado()

func mostrar_game_over():
	Global.resetear_juego()
	call_deferred("cambiar_escena_game_over", "res://Pantallas/derrota.tscn")

func cambiar_escena_game_over(ruta_escena):
	var escena = get_tree().current_scene
	escena = load(ruta_escena)
	if escena:
		get_tree().change_scene_to_file(ruta_escena)
	else:
		print("Error: No se pudo cargar la escena de derrota.")
		
func mostrar_juego_ganado():
	Global.resetear_juego()
	call_deferred("cambiar_escena_juego_ganado", "res://Pantallas/victoria.tscn")

func cambiar_escena_juego_ganado(ruta_escena):
	var escena = get_tree().current_scene
	escena = load(ruta_escena)
	if escena:
		get_tree().change_scene_to_file(ruta_escena)
	else:
		print("Error: No se pudo cargar la escena de derrota.")

func start_timer():
	tiempo_restante = Global.tiempo_inicial
	timer = Timer.new()
	timer.wait_time = 1
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	add_child(timer)
	timer.start()

func _on_Timer_timeout():
	if tiempo_restante > 0 and vidas_actuales > 0:
		tiempo_restante -= 1
		if label_tiempo:
			label_tiempo.text = "Tiempo: " + str(tiempo_restante)
	elif tiempo_restante == 0:
		mostrar_game_over()