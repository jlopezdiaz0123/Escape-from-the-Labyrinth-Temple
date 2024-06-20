extends Node3D

const LLAVE_SCENE_PATH = "res://Assets/llave.tscn"

var spawn_areas = []

func _ready():
	ControlJuego.initialize_scene_nodes()    
	var llave_scene = load(LLAVE_SCENE_PATH)
	var puntos_aparicion = get_node_or_null("puntosAparicionLlave")

	if puntos_aparicion == null:
		print("Nodo puntosAparicionLlave no encontrado.")
		return
	
	for i in range(1, 9):
		var area = puntos_aparicion.get_node_or_null("spawnLlave" + str(i))
		if area != null:
			spawn_areas.append(area)
		else:
			print("Nodo spawnLlave" + str(i) + " no encontrado.")
	
	if spawn_areas.size() == 0:
		print("No se encontraron nodos de aparición.")
		return
	
	var random_index = randi() % spawn_areas.size()
	var random_spawn_area = spawn_areas[random_index]
	
	var llave_instance = llave_scene.instantiate()
	random_spawn_area.add_child(llave_instance)
	
	llave_instance.global_transform = random_spawn_area.global_transform