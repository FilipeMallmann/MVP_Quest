extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var camera_pivot = $CameraPivot
@export var sensitivity = 0.3
@export var clip_top = -90
@export var clip_botton = 45
@export var inverse_mouse = false

var menu_active = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	var factor = -1
	if inverse_mouse:
		factor = 1
	else:
		factor = -1
	
	if event is InputEventMouseMotion && not menu_active:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity)*factor)
		camera_pivot.rotate_x(deg_to_rad(event.relative.y * sensitivity)*factor)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x,deg_to_rad(clip_top),deg_to_rad(clip_botton)*factor)
		
func _ready():
	toggle_menu()

func toggle_menu():
	menu_active = !menu_active
	if menu_active:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	
	
func handle_moviment(delta:float):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

func _physics_process(delta):
	if  not menu_active:
		handle_moviment(delta)

	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("menu"):
		toggle_menu()
