extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	open_main_menu()

func open_main_menu():
	$Zap.playing = true
	var main_menu = preload("res://scenes/main_menu/main_menu.tscn").instance()
	main_menu.connect("start_game", self, "on_start_game")
	add_child(main_menu)

func start_game():
	$Zap.playing = false
	var game_instance = preload("res://scenes/game/game.tscn").instance()
	game_instance.connect("game_lost", self, "on_game_lost")
	add_child(game_instance)
	
	
func open_death_screen():
	$Zap.playing = true
	var death_screen = preload("res://scenes/death_screen/death_screen.tscn").instance()
	death_screen.connect("close", self, "on_close_screen")
	add_child(death_screen)
	
	
func on_game_lost(game_instance):
	remove_child(game_instance)
	open_death_screen()
	
func on_close_screen(screen):
	remove_child(screen)
	open_main_menu()
	
func on_start_game(main_menu):
	remove_child(main_menu)
	start_game()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
