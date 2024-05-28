extends CharacterBody3D

const VELOCIDAD = 5.0
const VELOCIDAD_SALTO = 15

var gravedad: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var movimiento_raton := Vector2.ZERO
@onready var jugador_caminando_player: AudioStreamPlayer = $pasosJugador

var estado_jugador = 0
enum ESTADO {QUIETO, CAMINANDO, SALTANDO}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	handle_camera_rotation()
	if not is_on_floor():
		velocity.y -= gravedad * delta

	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = VELOCIDAD_SALTO

	var input_dir := Input.get_vector("mover_izquierda", "mover_derecha", "mover_adelante", "mover_atras")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * VELOCIDAD
		velocity.z = direction.z * VELOCIDAD
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCIDAD)
		velocity.z = move_toward(velocity.z, 0, VELOCIDAD)

	estado_jugador = get_estado_jugador()

	if estado_jugador == ESTADO.CAMINANDO:
		if not jugador_caminando_player.playing:
			jugador_caminando_player.play()
	elif jugador_caminando_player.playing:
		jugador_caminando_player.stop()

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			movimiento_raton = -event.relative * 0.001
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func handle_camera_rotation() -> void:
	rotate_y(movimiento_raton.x)
	var camera = $Camera3D
	camera.rotate_x(movimiento_raton.y)
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	movimiento_raton = Vector2.ZERO

func get_estado_jugador() -> int:
	var estado = ESTADO.QUIETO
	if is_on_floor():
		if Input.is_action_pressed("mover_izquierda") or Input.is_action_pressed("mover_derecha") or Input.is_action_pressed("mover_adelante") or Input.is_action_pressed("mover_atras"):
			estado = ESTADO.CAMINANDO
		elif Input.is_action_just_pressed("saltar"):
			estado = ESTADO.SALTANDO
	return estado