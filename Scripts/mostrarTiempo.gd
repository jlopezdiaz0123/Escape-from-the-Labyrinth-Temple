extends Label

func _ready():
	#if Global.con_tiempo == false:
		#queue_free()
	if  Global.con_tiempo == true:
		visible = true
	else:
		visible = false

func _process(_delta):
	pass