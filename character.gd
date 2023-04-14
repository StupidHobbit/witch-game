extends CharacterBody3D

class_name Character

@export var SPEED = 6.0
@export var RUNNING_SPEED = 10.0
@export var CROUCHING_SPEED = 4.0
@export var CROUCHING_DELTA = 0.5
@export var JUMP_VELOCITY = 6
@export var jumping_gravity: float = 15
@export var falling_gravity: float = 30
@export var jump_buffer: float = 0.1
@export var coyote_time: float = 0.1
@export var climbing_time_limit: float = 0.5
@export var climbing_speed: float = 4
@export var slowdown_time: float = 0.1
@export var crouching_animation_time: float = 0.2

var time_from_last_jump_press: float = 100 
var time_from_last_on_floor: float = 0 
var climbing_time: float = 0.5
var turn = Vector2(0, 0)
var viewport_size: Vector2
var movement_disabled: bool = false
var examinated_item: Examinable

@onready var camera = $Camera3D
@onready var holder = $Camera3D/Holder
@onready var anim_component = $character_animation

func _ready():
	viewport_size = get_viewport().size / 2

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func examine(item: Examinable, collision_rid: RID):
	item.reparent(holder)
	holder.add_excluded_object(collision_rid)
	examinated_item = item
	disable_movement()

func _physics_process(delta: float):
	update_examination()
	if movement_disabled:
		return
	apply_vertical_movement(delta)
	apply_rotation()
	apply_horizontal_movement(delta)
	apply_crouching(delta)
	move_and_slide()

func apply_vertical_movement(delta: float):
	var jump_just_pressed = Input.is_action_just_pressed("jump")
	if jump_just_pressed:
		time_from_last_jump_press = 0
	time_from_last_jump_press += delta
	
	var jump_pressed = Input.is_action_pressed("jump")
	var is_on_floor = is_on_floor()
	if is_on_floor:
		time_from_last_on_floor = 0
		climbing_time = 0
	time_from_last_on_floor += delta
	
	if not is_on_floor:
		if is_climbing(jump_pressed):
			velocity.y = climbing_speed
			climbing_time += delta
		
		var gravity = jumping_gravity if velocity.y > 0 and jump_pressed else falling_gravity
		velocity.y -= gravity * delta

	if time_from_last_jump_press < jump_buffer and time_from_last_on_floor < coyote_time:
		velocity.y = JUMP_VELOCITY

func apply_rotation():
	var rotation = turn * PI / viewport_size
	global_rotation = Vector3(global_rotation.x, -rotation.x, 0)
	camera.rotation = Vector3(-rotation.y, 0, 0)

func apply_crouching(delta: float):
	var to = 0
	
	if is_crouching():
		to = -CROUCHING_DELTA
	camera.position.y = move_toward(camera.position.y, to, CROUCHING_DELTA * delta / crouching_animation_time)

func apply_horizontal_movement(delta: float):
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var speed = get_current_speed()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if is_on_floor():
			anim_component.move()
	else:
		anim_component.be_idle()
		velocity.x = move_toward(velocity.x, 0, speed * delta / slowdown_time)
		velocity.z = move_toward(velocity.z, 0, speed * delta / slowdown_time)
		
func update_examination():
	if examinated_item == null or Input.is_action_pressed("interact"):
		return
	examinated_item.put_back()
	examinated_item = null
	enable_movement()
	holder.clear_excluded_objects()

func is_crouching()  -> bool:
	return Input.is_action_pressed("crouch")

func is_running() -> bool:
	return Input.is_action_pressed("run")

func is_climbing(jump_pressed: bool) -> bool:
	return climbing_time <= climbing_time_limit and jump_pressed and is_on_wall()
	
func disable_movement():
	movement_disabled = true

func enable_movement():
	movement_disabled = false

func get_current_speed() -> float:
	if is_crouching():	
		return CROUCHING_SPEED
	if is_running():
		return RUNNING_SPEED
	return SPEED

func _process(delta: float):
	pass

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if examinated_item != null:
			examinated_item.rotation.x += event.relative.y * PI / viewport_size.y
			examinated_item.rotation.y += event.relative.x * PI / viewport_size.x
			return
			
		turn += event.relative
	turn.y = clampf(turn.y, -viewport_size.y / 2, viewport_size.y / 2)
