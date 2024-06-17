extends CharacterBody3D

const VELOCIDAD = 5.0
const VELOCIDAD_GIRO = 2.0

var gravedad: float = ProjectSettings.get_setting("physics/3d/default_gravity")

const RANGO_MOVIMIENTO_ALEATORIO = 20.0
var objetivo_aleatorio = Vector3.ZERO
var tiempo_cambio_objetivo = 0.0
var intervalo_cambio_objetivo = 3.0

var tiempo_atascado = 0.0
var tiempo_limite_atasco = 0.25
var ultima_posicion = Vector3.ZERO

@onready var camara = $Camera3D

func _ready() -> void:
    _establecer_objetivo_aleatorio()

func _process(_delta: float) -> void:
    _movimiento_aleatorio(_delta)

func _physics_process(delta: float) -> void:
    var siguiente_posicion = objetivo_aleatorio
    if not is_on_floor():
        velocity.y -= gravedad * delta

    var direccion = global_position.direction_to(siguiente_posicion)
    
    if direccion:
        var velocidad_ajustada = VELOCIDAD
        if _cerca_de_esquina():
            velocidad_ajustada = VELOCIDAD_GIRO 
        velocity.x = direccion.x * velocidad_ajustada
        velocity.z = direccion.z * velocidad_ajustada
    else:
        velocity.x = move_toward(velocity.x, 0, VELOCIDAD)
        velocity.z = move_toward(velocity.z, 0, VELOCIDAD)

    move_and_slide()

    _evitar_obstaculos()

    _comprobar_atasco(delta)

func _movimiento_aleatorio(delta: float) -> void:
    tiempo_cambio_objetivo -= delta
    if tiempo_cambio_objetivo <= 0:
        _establecer_objetivo_aleatorio()
        tiempo_cambio_objetivo = intervalo_cambio_objetivo

func _establecer_objetivo_aleatorio() -> void:
    var x = randf_range(-RANGO_MOVIMIENTO_ALEATORIO, RANGO_MOVIMIENTO_ALEATORIO)
    var z = randf_range(-RANGO_MOVIMIENTO_ALEATORIO, RANGO_MOVIMIENTO_ALEATORIO)
    objetivo_aleatorio = global_position + Vector3(x, 0, z)

func _evitar_obstaculos() -> void:
    var inicio_rayo = global_position
    var fin_rayo = inicio_rayo + global_transform.basis.z * 2.0
    var estado_espacio = get_world_3d().direct_space_state
    var consulta = PhysicsRayQueryParameters3D.new()
    consulta.from = inicio_rayo
    consulta.to = fin_rayo
    consulta.exclude = [self.get_rid()]
    
    var resultado = estado_espacio.intersect_ray(consulta)
    
    if resultado:
        var normal = resultado.normal
        velocity.x += normal.x * VELOCIDAD
        velocity.z += normal.z * VELOCIDAD
        _establecer_objetivo_aleatorio()

func _cerca_de_esquina() -> bool:
    var inicio_rayo_izquierda = global_position - global_transform.basis.x * 0.5
    var fin_rayo_izquierda = inicio_rayo_izquierda + global_transform.basis.z * 2.0
    var inicio_rayo_derecha = global_position + global_transform.basis.x * 0.5
    var fin_rayo_derecha = inicio_rayo_derecha + global_transform.basis.z * 2.0
    
    var estado_espacio = get_world_3d().direct_space_state
    var consulta_izquierda = PhysicsRayQueryParameters3D.new()
    consulta_izquierda.from = inicio_rayo_izquierda
    consulta_izquierda.to = fin_rayo_izquierda
    consulta_izquierda.exclude = [self.get_rid()]
    
    var consulta_derecha = PhysicsRayQueryParameters3D.new()
    consulta_derecha.from = inicio_rayo_derecha
    consulta_derecha.to = fin_rayo_derecha
    consulta_derecha.exclude = [self.get_rid()]
    
    var resultado_izquierda = estado_espacio.intersect_ray(consulta_izquierda)
    var resultado_derecha = estado_espacio.intersect_ray(consulta_derecha)
    
    return resultado_izquierda or resultado_derecha

func _comprobar_atasco(delta: float) -> void:
    if global_position.distance_to(ultima_posicion) < 0.1:
        tiempo_atascado += delta
        if tiempo_atascado > tiempo_limite_atasco:
            _girar_para_desatascar()
    else:
        tiempo_atascado = 0.0

    ultima_posicion = global_position

func _girar_para_desatascar() -> void:
    var nueva_direccion = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
    velocity.x = nueva_direccion.x * VELOCIDAD
    velocity.z = nueva_direccion.z * VELOCIDAD
    _establecer_objetivo_aleatorio()