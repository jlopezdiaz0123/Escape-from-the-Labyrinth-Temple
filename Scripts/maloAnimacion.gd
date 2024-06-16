extends Node3D

@onready var reproductor_animacion = $AnimationPlayer

func _ready() -> void:
    reproductor_animacion.play("Animation")