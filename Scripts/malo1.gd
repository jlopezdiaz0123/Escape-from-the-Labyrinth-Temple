extends CharacterBody3D

const VELOCIDAD = 5.0
const VELOCIDAD_SALTO = 4.5
const VELOCIDAD_GIRO = 2.0 # Nueva constante para velocidad al girar

var gravedad: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var agente_navegacion_3d: NavigationAgent3D = $NavigationAgent3D
@onready var reproductor_animacion = $AnimationPlayer

var jugador: Node
var provocado := false
var rango_aggro := 100.0

const RANGO_MOVIMIENTO_ALEATORIO = 20.0
var objetivo_aleatorio = Vector3.ZERO
var tiempo_cambio_objetivo = 0.0
var intervalo_cambio_objetivo = 3.0

func _ready() -> void:
    reproductor_animacion.play("Animation")
    jugador = get_tree().get_first_node_in_group("player")
    if jugador == null:
        print("¡Nodo del jugador no encontrado en la escena!")
        return
    _establecer_objetivo_aleatorio()
    agente_navegacion_3d.radius = 0.5 # Ajusta el radio de colisión si es necesario

func _process(_delta: float) -> void:
    if jugador == null:
        return
        
    if provocado:
        agente_navegacion_3d.target_position = jugador.global_position
    else:
        _movimiento_aleatorio(_delta)

func _physics_process(delta: float) -> void:
    if jugador == null:
        return
        
    var siguiente_posicion = agente_navegacion_3d.get_next_path_position()
    if not is_on_floor():
        velocity.y -= gravedad * delta

    var direccion = global_position.direction_to(siguiente_posicion)
    var distancia = global_position.distance_to(jugador.global_position)
    
    if distancia <= rango_aggro:
        provocado = true
    
    if direccion:
        var velocidad_ajustada = VELOCIDAD
        if _cerca_de_esquina():
            velocidad_ajustada = VELOCIDAD_GIRO # Reduce la velocidad al girar
        velocity.x = direccion.x * velocidad_ajustada
        velocity.z = direccion.z * velocidad_ajustada
    else:
        velocity.x = move_toward(velocity.x, 0, VELOCIDAD)
        velocity.z = move_toward(velocity.z, 0, VELOCIDAD)

    move_and_slide()

    if provocado:
        _mirar_al_jugador(delta)
    else:
        _evitar_obstaculos()

func _movimiento_aleatorio(delta: float) -> void:
    tiempo_cambio_objetivo -= delta
    if tiempo_cambio_objetivo <= 0:
        _establecer_objetivo_aleatorio()
        tiempo_cambio_objetivo = intervalo_cambio_objetivo
    
    agente_navegacion_3d.target_position = objetivo_aleatorio

func _establecer_objetivo_aleatorio() -> void:
    var desplazamiento_aleatorio = Vector3(
        randf_range( - RANGO_MOVIMIENTO_ALEATORIO, RANGO_MOVIMIENTO_ALEATORIO),
        0,
        randf_range( - RANGO_MOVIMIENTO_ALEATORIO, RANGO_MOVIMIENTO_ALEATORIO)
    )
    objetivo_aleatorio = global_position + desplazamiento_aleatorio

func _mirar_al_jugador(delta: float) -> void:
    var hacia_jugador = jugador.global_position - global_position
    hacia_jugador.y = 0
    hacia_jugador = hacia_jugador.normalized()
    var rotacion_objetivo = -atan2(hacia_jugador.z, hacia_jugador.x)
    var desplazamiento_rotacion = deg_to_rad(90)
    rotation.y = lerp_angle(rotation.y, rotacion_objetivo + desplazamiento_rotacion, delta * 5)

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
