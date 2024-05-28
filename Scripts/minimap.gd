extends Camera3D

@export var target: NodePath
@onready var player = get_node(target)

func _process (_delta: float) -> void:
	position = Vector3(player.position.x, 30, player.position.z)
