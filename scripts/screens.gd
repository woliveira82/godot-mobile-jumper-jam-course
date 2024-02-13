extends CanvasLayer

@onready var console = $Debug/ConsoleLog
@onready var title_screen = $TitleScreen
@onready var pause_screen = $PauseScreen
@onready var game_over_screen = $GameOverScreen

var current_screen = null


func _ready():
	console.visible = false
	register_buttons()
	change_screen(title_screen)


func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	if buttons.size() > 0:
		for button in buttons:
			if button is ScreenButton:
				button.clicked.connect(_on_button_pressed)


func _on_button_pressed(button):
	match button.name:
		"TitlePlay":
			change_screen(pause_screen)
		"PauseRetry":
			change_screen(game_over_screen)
		"PauseBack":
			change_screen(null)
		"PauseClose":
			print("PauseClose")
		"GameOverRetry":
			change_screen(title_screen)
		"GameOverBack":
			print("GameOverBack")


func _process(_delta):
	pass


func _on_toggle_console_pressed():
	console.visible = not console.visible


func change_screen(new_screen):
	if current_screen:
		await current_screen.disappear()
	
	current_screen = new_screen
	if current_screen:
		current_screen.appear()
