extends CharacterBody2D
class_name Player

var speed = 300.0
var accelerometer_speed = 130.0

var gravity = 15.0
var max_fall_velocity = 1000
var jump_velocity = -800

var viewport_size
var use_accelerometer = false

@onready var animator = $AnimationPlayer


func _ready():
	viewport_size = get_viewport_rect().size
	var os_name = OS.get_name()
	use_accelerometer = os_name in ["Android", "iOS"]


func _process(_delta):
	if velocity.y > 0:
		if animator.current_animation != "fall":
			animator.play("fall")
	elif velocity.y < 0:
		if animator.current_animation != "jump":
			animator.play("jump")


func _physics_process(_delta):
	velocity.y += gravity
	velocity.y = min(velocity.y, max_fall_velocity)
	
	if use_accelerometer:
		var mobile_input = Input.get_accelerometer()
		velocity.x = mobile_input.x * accelerometer_speed
	else:
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	
	var margin = 20
	if global_position.x > viewport_size.x + margin:
		global_position.x = -margin
	elif global_position.x < -margin:
		global_position.x = viewport_size.x + margin


func jump():
	velocity.y = jump_velocity
