extends CanvasLayer

signal start_game
signal delete_level

var current_screen = null

@onready var console = $Debug/ConsoleLog
@onready var title_screen = $TitleScreen
@onready var pause_screen = $PauseScreen
@onready var game_over_screen = $GameOverScreen
@onready var game_over_score_label = $GameOverScreen/Box/ScoreLabel
@onready var game_over_high_score_label = $GameOverScreen/Box/HighScoreLabel


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
			change_screen(null)
			await get_tree().create_timer(0.5).timeout
			start_game.emit()
		"PauseRetry":
			change_screen(null)
			await get_tree().create_timer(0.5).timeout
			get_tree().paused = false
			start_game.emit()
		"PauseBack":
			change_screen(title_screen)
			get_tree().paused = false
			delete_level.emit()
		"PauseClose":
			change_screen(null)
			await get_tree().create_timer(0.75).timeout
			get_tree().paused = false
		"GameOverRetry":
			change_screen(null)
			await get_tree().create_timer(0.5).timeout
			start_game.emit()
		"GameOverBack":
			change_screen(title_screen)
			delete_level.emit()


func _on_toggle_console_pressed():
	console.visible = not console.visible


func change_screen(new_screen):
	if current_screen:
		await current_screen.disappear()
	
	current_screen = new_screen
	if current_screen:
		current_screen.appear()


func game_over(score, highscore):
	game_over_score_label.text = "Score: %d" % score
	game_over_high_score_label.text = "Best: %d" % highscore
	change_screen(game_over_screen)


func pause_game():
	change_screen(pause_screen)
