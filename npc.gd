extends CharacterBody2D

@export var npc_name = "Village Helper"
@export var sacrifice_vitality_value = 80.0
var player_nearby = false
var player_ref = null

func _ready():
	# Connect the Area2D signal for player detection
	$Area2D.body_entered.connect(_on_player_entered)
	$Area2D.body_exited.connect(_on_player_exited)

func _process(delta):
	# Show interaction when player is near and presses Space
	if player_nearby and Input.is_action_just_pressed("ui_accept"):
		show_sacrifice_choice()

func _on_player_entered(body):
	if body.name == "Player":
		player_nearby = true
		player_ref = body
		print("Press SPACE to interact with NPC")

func _on_player_exited(body):
	if body.name == "Player":
		player_nearby = false
		player_ref = null

func show_sacrifice_choice():
	print("=== MORAL CHOICE ===")
	print("Sacrifice NPC for 80 vitality?")
	print("Press LEFT ARROW to SACRIFICE, RIGHT ARROW to spare")
	
	# Wait for player choice
	await make_choice()

func make_choice():
	while true:
		await get_tree().process_frame
		
		if Input.is_action_just_pressed("ui_left"):
			sacrifice_npc()
			break
		elif Input.is_action_just_pressed("ui_right"):
			print("You spared the NPC. They will help you later...")
			break

func sacrifice_npc():
	print("You sacrificed the NPC! +80 vitality")
	print("The parasite feeds... but at what cost?")
	
	if player_ref and player_ref.has_method("restore_vitality"):
		player_ref.restore_vitality(80.0)
	
	queue_free()  # Remove NPC from game
