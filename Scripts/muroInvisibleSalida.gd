extends StaticBody3D

func _ready():
	pass

func _process(_delta):
	if ControlJuego.llave_obtenida == true:
		queue_free()