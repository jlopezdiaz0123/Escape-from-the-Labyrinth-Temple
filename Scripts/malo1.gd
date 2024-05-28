extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player = $AnimationPlayer

var player: Node
var provoked := false
var aggro_range := 12.0

const RANDOM_MOVE_RANGE = 20.0
var random_target = Vector3.ZERO
var change_target_time = 0.0
var target_change_interval = 3.0

func _ready() -> void:
	animation_player.play("Animation")
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("Player node not found in the scene!")
		return
	_set_random_target()

func _process(_delta: float) -> void:
	if player == null:
		return
		
	if provoked:
		navigation_agent_3d.target_position = player.global_position
	else:
		_random_movement(_delta)

func _physics_process(delta: float) -> void:
	if player == null:
		return
		
	var next_position = navigation_agent_3d.get_next_path_position()
	if not is_on_floor():
		velocity.y -= gravity * delta

	var direction = global_position.direction_to(next_position)
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= aggro_range:
		provoked = true
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	if provoked:
		_look_at_player(delta)

func _random_movement(delta: float) -> void:
	change_target_time -= delta
	if change_target_time <= 0:
		_set_random_target()
		change_target_time = target_change_interval
	
	navigation_agent_3d.target_position = random_target

func _set_random_target() -> void:
	var random_offset = Vector3(
		randf_range(-RANDOM_MOVE_RANGE, RANDOM_MOVE_RANGE),
		0,
		randf_range(-RANDOM_MOVE_RANGE, RANDOM_MOVE_RANGE)
	)
	random_target = global_position + random_offset

func _look_at_player(delta: float) -> void:
	var to_player = player.global_position - global_position
	to_player.y = 0
	to_player = to_player.normalized()
	var target_rotation = -atan2(to_player.z, to_player.x)
	var rotation_offset = deg_to_rad(90)
	rotation.y = lerp_angle(rotation.y, target_rotation + rotation_offset, delta * 5)