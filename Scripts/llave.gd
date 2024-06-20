extends Area3D
signal llave_recogida

var control_juego

func _ready():
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))
	control_juego = get_node("/root/ControlJuego")

func _on_body_entered(body):
	if body.is_in_group("Jugador"):
		ControlJuego.llave_obtenida = true
		queue_free()
