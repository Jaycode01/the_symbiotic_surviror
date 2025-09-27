extends CharacterBody2D
signal player_died

@export var speed = 300.0
@export var vitality_drain_rate = 2.0
var vitality = 100.0


func _physics_process(delta):
	# Get input direction
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Move player
	velocity = input_dir * speed
	move_and_slide()
	
	# Drain vitality over time
	vitality -= vitality_drain_rate * delta
	print("Vitality: ", vitality)
	
	# Die if vitality reaches 0
	if vitality <= 0:
		print("You died!")
		player_died.emit()  # Emit the signal instead of reloading immediately
		vitality = 0  # Prevent negative vitality

func restore_vitality(amount):
	vitality += amount
	if vitality > 100.0:
		vitality = 100.0  # Cap at maximum
	print("Vitality restored! Current: ", vitality)
