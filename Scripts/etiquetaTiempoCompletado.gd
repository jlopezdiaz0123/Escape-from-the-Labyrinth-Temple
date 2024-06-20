extends Control

func _ready():
	var label_tiempo_completado = $LabelTiempoCompletado
	label_tiempo_completado.text = "Tiempo completado: " + str(ControlJuego.tiempo_completado)