extends Label

func _ready():
	if Global.con_tiempo == false:
		queue_free()

func _process(_delta):
	pass