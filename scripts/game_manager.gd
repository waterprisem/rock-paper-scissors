extends Node

@onready var message_box = $"../message"
var shader_material_player
var shader_material_bot
var target_node_player
var target_node_bot

var input = ""
var game_on = false
var computer_move = ""
var moves = ["rock", "paper", "scissors"]
var result = ""

signal game_end(result)


func _ready() -> void:
	new_game()

func new_game():
	var shader = load("res://shader/color.gdshader")
	shader_material_player = ShaderMaterial.new() 
	shader_material_player.shader = shader
	shader_material_bot = ShaderMaterial.new() 
	shader_material_bot.shader = shader
	
	message_box.text="make your move"
	input = ""
	computer_move = moves.pick_random()
	game_on = true

func run_results():
	message_box.text="results in..."
	await get_tree().create_timer(0.5).timeout
	message_box.text="3..."
	await get_tree().create_timer(0.5).timeout
	message_box.text="2..."
	await get_tree().create_timer(0.5).timeout
	message_box.text="1..."
	await get_tree().create_timer(0.5).timeout

func _on_rock_pressed() -> void:
	if game_on:
		target_node_player = $"../VBoxContainer/player control/HBoxContainer/rock"
		input = "rock"
		run_results()
		game_on = false
		await run_results()
		if computer_move == "scissors":
			message_box.text = str("you won :D")
			target_node_bot = $"../VBoxContainer/computer control/HBoxContainer/scissors"
			target_node_player.material = shader_material_player
			target_node_bot.material = shader_material_bot
			player_win()
		elif computer_move =="paper":
			message_box.text = str("you lost D:")
			target_node_bot = $"../VBoxContainer/computer control/HBoxContainer/paper"
			target_node_player.material = shader_material_player
			target_node_bot.material = shader_material_bot
			bot_win()
		else:
			message_box.text = str("it's a tie :o")
			target_node_bot = $"../VBoxContainer/computer control/HBoxContainer/rock"
			target_node_player.material = shader_material_player
			target_node_bot.material = shader_material_bot
			tie()
		await get_tree().create_timer(2.0).timeout
		reset_tint()
		new_game()


func _on_paper_pressed() -> void:
	if game_on:
		target_node_player = $"../VBoxContainer/player control/HBoxContainer/paper"
		input = "paper"
		run_results()
		game_on = false
		await run_results()
		if computer_move == "rock":
			message_box.text = str("you won :D")
			target_node_bot = $"../VBoxContainer/computer control/HBoxContainer/rock"
			target_node_player.material = shader_material_player
			target_node_bot.material = shader_material_bot
			player_win()
		elif computer_move =="scissors":
			target_node_bot = $"../VBoxContainer/computer control/HBoxContainer/scissors"
			target_node_player.material = shader_material_player
			target_node_bot.material = shader_material_bot
			message_box.text = str("you lost D:")
			bot_win()
		else:
			message_box.text = str("it's a tie :o")
			target_node_bot = $"../VBoxContainer/computer control/HBoxContainer/paper"
			target_node_player.material = shader_material_player
			target_node_bot.material = shader_material_bot
			tie()
		await get_tree().create_timer(2.0).timeout
		reset_tint()
		new_game()


func _on_scissors_pressed() -> void:
	if game_on:
		target_node_player = $"../VBoxContainer/player control/HBoxContainer/scissors"
		input = "scissors"
		run_results()
		game_on = false
		await run_results()
		if computer_move == "paper":
			message_box.text = str("you won :D")

			target_node_bot = $"../VBoxContainer/computer control/HBoxContainer/paper"
			target_node_player.material = shader_material_player
			target_node_bot.material = shader_material_bot
			
			player_win()
			
		elif computer_move =="rock":
			message_box.text = str("you lost D:")
			
			target_node_bot = $"../VBoxContainer/computer control/HBoxContainer/rock"
			target_node_player.material = shader_material_player
			target_node_bot.material = shader_material_bot
			
			bot_win()
		else:
			target_node_bot = $"../VBoxContainer/computer control/HBoxContainer/scissors"
			target_node_player.material = shader_material_player
			target_node_bot.material = shader_material_bot
			message_box.text = str("it's a tie :o")
			tie()
		await get_tree().create_timer(2.0).timeout
		reset_tint()
		
		new_game()
		
		
func player_win():
	result = "win"
	emit_signal("game_end", "win")
	shader_material_player.set_shader_parameter("tint_color", Color(0.7, 1.0, 0.7, 1.0)) #green
	shader_material_bot.set_shader_parameter("tint_color", Color(1.0, 0.7, 0.7, 1.0)) # red

func reset_tint():
	shader_material_player.set_shader_parameter("tint_color", Color(1.0, 1.0, 1.0, 1.0))
	shader_material_bot.set_shader_parameter("tint_color", Color(1.0, 1.0, 1.0, 1.0))
	if target_node_player:
			target_node_player.material = null
	if target_node_bot:
		target_node_bot.material = null


# You can also add other tints
func bot_win():
	result = "loss"
	emit_signal("game_end", result)
	shader_material_bot.set_shader_parameter("tint_color", Color(0.7, 1.0, 0.7, 1.0)) #green
	shader_material_player.set_shader_parameter("tint_color", Color(1.0, 0.7, 0.7, 1.0)) # red

func tie():
	result = "tie"
	emit_signal("game_end", result)
	shader_material_bot.set_shader_parameter("tint_color", Color(1, 0.9, 0.7, 1)) #yellow
	shader_material_player.set_shader_parameter("tint_color", Color(1, 0.9, 0.6, 1)) # yellow
