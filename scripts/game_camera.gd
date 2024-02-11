extends Camera2D

var player: Player = null
var limit_distance = 420
var viewport_size

@onready var destroyer = $Destroyer
@onready var destroyer_shape = $Destroyer/CollisionShape2D


func _ready():
	viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x / 2
	limit_left = 0
	limit_bottom = viewport_size.y
	limit_right = viewport_size.x
	
	destroyer.position.y = viewport_size.y
	
	var rect_shape = RectangleShape2D.new()
	var rect_shape_size = Vector2(viewport_size.x, 200)
	rect_shape.set_size(rect_shape_size)
	destroyer_shape.shape = rect_shape


func _process(_delta):
	if player:
		limit_bottom = min(limit_bottom, player.global_position.y + limit_distance)
	
	var overlaping_areas = destroyer.get_overlapping_areas()
	if overlaping_areas.size() > 0:
		for area in overlaping_areas:
			if area is Platform:
				area.queue_free()


func _physics_process(_delta):
	if player:
		global_position.y = player.global_position.y


func setup_camera(_player: Player):
	if _player:
		player = _player
