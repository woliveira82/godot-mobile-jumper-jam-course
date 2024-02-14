extends Node2D

signal player_died(score, highscore)
signal pause_game

var camera_scene = preload("res://scenes/game_camera.tscn")
var player_scene = preload("res://scenes/player.tscn")

var camera = null
var player: Player = null
var player_spawn_position: Vector2
var viewport_size: Vector2
var score: int = 0
var high_score: int = 0
var save_file_path = "user://highscore.save"


@onready var level_generator = $LevelGenerator
@onready var ground_sprite = $GroundSprite
@onready var parallax1 = $ParallaxBackground/ParallaxLayer1
@onready var parallax2 = $ParallaxBackground/ParallaxLayer2
@onready var parallax3 = $ParallaxBackground/ParallaxLayer3
@onready var hud = $UILayer/HUD


func _ready():
	viewport_size = get_viewport_rect().size
	var player_spawn_pos_y_offset = 135
	player_spawn_position.x = viewport_size.x / 2
	player_spawn_position.y = viewport_size.y - player_spawn_pos_y_offset
	
	ground_sprite.global_position.x = viewport_size.x / 2
	ground_sprite.global_position.y = viewport_size.y
	
	setup_parallax_layer(parallax1)
	setup_parallax_layer(parallax2)
	setup_parallax_layer(parallax3)
	
	hud.visible = false
	hud.set_score(0)
	hud.pause_game.connect(_on_hud_pause_game)
	ground_sprite.visible = false
	
	load_score()


func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if player:
		score = max(score, viewport_size.y - player.global_position.y)
		hud.set_score(score)


func new_game():
	reset_game()
	
	player = player_scene.instantiate()
	player.global_position = player_spawn_position
	player.died.connect(_on_player_died)
	add_child(player)
	
	camera = camera_scene.instantiate()
	camera.setup_camera(player)
	add_child(camera)

	if player:
		level_generator.setup(player)
		level_generator.start_generation()
	
	hud.visible = true
	ground_sprite.visible = true
	score = 0


func get_parallax_sprite_scale(parallax_sprite: Sprite2D):
	var parallax_texture = parallax_sprite.get_texture()
	var parallax_texture_width = parallax_texture.get_width()
	var _scale = viewport_size.x / parallax_texture_width
	var result = Vector2(_scale, _scale)
	return result


func setup_parallax_layer(parallax_layer: ParallaxLayer):
	var parallax_sprite = parallax_layer.find_child("Sprite2D")
	if parallax_sprite:
		parallax_sprite.scale = get_parallax_sprite_scale(parallax_sprite)
		var my = parallax_sprite.scale.y * parallax_sprite.get_texture().get_height()
		parallax_layer.motion_mirroring.y = my


func _on_player_died():
	hud.visible = false
	
	high_score = max(high_score, score)
	save_score()
	player_died.emit(score, high_score)


func reset_game():
	ground_sprite.visible = false
	hud.set_score(0)
	hud.visible = false
	level_generator.reset_level()
	if player:
		player.queue_free()
		player = null
		level_generator.player = null
	
	if camera:
		camera.queue_free()
		camera = null


func save_score():
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	file.store_var(high_score)
	file.close()


func load_score():
	if FileAccess.file_exists(save_file_path):
		var file = FileAccess.open(save_file_path, FileAccess.READ)
		high_score = file.get_var()
		file.close()
	else:
		high_score = 0


func _on_hud_pause_game():
	pause_game.emit()
