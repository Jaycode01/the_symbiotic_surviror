extends Area2D

@export var vitality_value = 30.0

func _ready():
	# Connect the signal when player enters
	body_entered.connect(_on_player_entered)

func _on_player_entered(body):
	# Check if it's the player
	if body.name == "Player":
		# Give vitality to player
		if body.has_method("restore_vitality"):
			body.restore_vitality(vitality_value)
			print("Sacrificed resource! Gained ", vitality_value, " vitality")
			# Remove the resource
			queue_free()
