extends Node
var Menu
var Volver
var LabelPausa
var FondoPausa

func _ready():
	Menu = $Opciones/Menu
	Volver = $Opciones/Volver
	LabelPausa = $Label
	FondoPausa = $FondoPausa
	
	Menu.visible = false
	Volver.visible = false
	LabelPausa.visible = false
	FondoPausa.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("pausar") and ControlJuego.jugador:
		Global.pausa = true
		get_tree().paused = true
	if Global.pausa:
		Menu.visible = true
		Volver.visible = true
		LabelPausa.visible = true
		FondoPausa.visible = true
	else:
		Menu.visible = false
		Volver.visible = false
		LabelPausa.visible = false
		FondoPausa.visible = false
		
func _on_menu_pressed():
	get_tree().paused = false
	Global.pausa = false
	ir_al_menu_principal()


func _on_volver_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	Global.pausa = false

func ir_al_menu_principal():
	Global.resetear_juego()
	call_deferred("cambiar_escena_menu", "res://Pantallas/menuInicio.tscn")

func cambiar_escena_menu(ruta_escena):
	var escena = get_tree().current_scene
	escena = load(ruta_escena)
	if escena:
		get_tree().change_scene_to_file(ruta_escena)
	else:
		print("Error: No se pudo cargar el menu principal.")