extends Node2D

var camera_scene = preload("res://scenes/game_camera.tscn")
var camera = null

@onready var player = $Player
@onready var level_generator = $LevelGenerator


func _ready():
	camera = camera_scene.instantiate()
	camera.setup_camera($Player)
	add_child(camera)

	if player:
		level_generator.setup(player)


func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
