extends Control
@export var aplausos_path : String = "res://Sonido/applauses.wav"
var tiempo_completado = Global.tiempo_inicial - ControlJuego.tiempo_restante
var aplausos : AudioStreamPlayer

func _ready():
	aplausos = AudioStreamPlayer.new()
	aplausos.stream = load(aplausos_path)
	add_child(aplausos)
	if not aplausos.playing:
		aplausos.play()

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Global.con_tiempo == true:
		var label_tiempo_completado = $LabelTiempoCompletado
		label_tiempo_completado.text = "Nivel completado en: " + str(tiempo_completado) + " segundos."

func _process(_delta):
	pass
func _on_boton_volver_pressed():
	get_tree().change_scene_to_file("res://Pantallas/menuInicio.tscn")