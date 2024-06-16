extends Camera3D

@export var objetivo: NodePath
@onready var jugador = get_node(objetivo)

func _process(_delta: float) -> void:
	position = Vector3(jugador.position.x, 30, jugador.position.z)