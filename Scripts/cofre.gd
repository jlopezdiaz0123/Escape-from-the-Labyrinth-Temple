extends Area3D

signal cofre_recogido
var control_juego

func _ready():

    if not is_connected("body_entered", Callable(self, "_on_body_entered")):

        connect("body_entered", Callable(self, "_on_body_entered"))

    control_juego = get_node("/root/ControlJuego")

func _on_body_entered(body):
    if body.is_in_group("Jugador"):

        emit_signal("cofre_recogido")

        if control_juego:
            control_juego._on_Cofre_area_entered(self)
        queue_free()