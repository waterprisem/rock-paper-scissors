extends Node2D

@export var high_score = 0
@export var low_score = 0
@export var points = 0
@export var wins = 0
@export var loss = 0
@export var ties = 0
var total_games = 0


func _ready() -> void:
	var game_scene = preload("res://game.tscn").instantiate() 
	add_child(game_scene)
	
	var game_manager = game_scene.get_node("GameManager")
	game_manager.connect("game_end", update_data)

func update_data(result):
	print("Game ended with: ", result)
	# Handle the win/loss/tie logic here
	match result:
		"win":
			points +=1
			wins +=1
			total_games +=1
		"loss": 
			points -=1
			loss +=1
			total_games +=1
		"tie":
			ties +=1
			total_games +=1
	update_text()
			
func update_text():
	if points > high_score:
		high_score=points
	if points < low_score:
		low_score=points
	$VBoxContainer/highest.text = str("High score: ", high_score)
	$VBoxContainer/lowest.text = str("Low score: ", low_score)
	$points.text = str(points)
	$VBoxContainer/wins.text = str("Wins: ", wins)
	$VBoxContainer/loss.text = str("Losses: ", loss)
	$VBoxContainer/ties.text = str("Ties: ", ties)
	$"VBoxContainer/total games".text = str("Games played: ", total_games)
