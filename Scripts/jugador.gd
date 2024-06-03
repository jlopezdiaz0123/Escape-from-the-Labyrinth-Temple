extends CharacterBody3D

const VELOCIDAD = 5.0
const VELOCIDAD_SALTO = 15.0

var gravedad: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var movimiento_raton := Vector2.ZERO
@onready var reproductor_pasos_jugador: AudioStreamPlayer = $pasosJugador

var estado_jugador = 0
enum ESTADO {QUIETO, CAMINANDO, SALTANDO}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	manejar_rotacion_camara()
	if not is_on_floor():
		velocity.y -= gravedad * delta

	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = VELOCIDAD_SALTO

	var direccion_entrada := Input.get_vector("mover_izquierda", "mover_derecha", "mover_adelante", "mover_atras")
	var direccion := (transform.basis * Vector3(direccion_entrada.x, 0, direccion_entrada.y)).normalized()
	if direccion.length() > 0:
		velocity.x = direccion.x * VELOCIDAD
		velocity.z = direccion.z * VELOCIDAD
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCIDAD)
		velocity.z = move_toward(velocity.z, 0, VELOCIDAD)

	move_and_slide()

	estado_jugador = obtener_estado_jugador()

	if estado_jugador == ESTADO.CAMINANDO:
		if not reproductor_pasos_jugador.playing:
			reproductor_pasos_jugador.play()
	elif reproductor_pasos_jugador.playing:
		reproductor_pasos_jugador.stop()

func _input(evento: InputEvent) -> void:
	if evento is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			movimiento_raton = -evento.relative * 0.001 # Ajusta la sensibilidad del ratón según sea necesario
	if evento.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func manejar_rotacion_camara() -> void:
	rotate_y(movimiento_raton.x)
	var camara = $Camera3D
	camara.rotate_x(movimiento_raton.y)
	camara.rotation_degrees.x = clamp(camara.rotation_degrees.x, -90, 90)
	movimiento_raton = Vector2.ZERO

func obtener_estado_jugador() -> int:
	var estado = ESTADO.QUIETO
	if is_on_floor():
		if Input.is_action_pressed("mover_izquierda") or Input.is_action_pressed("mover_derecha") or Input.is_action_pressed("mover_adelante") or Input.is_action_pressed("mover_atras"):
			estado = ESTADO.CAMINANDO
		elif not is_on_floor():
			estado = ESTADO.SALTANDO
	return estado
