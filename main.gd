extends Node2D

@onready var player = $Player
@onready var vitality_bar = $CanvasLayer/Control/ProgressBar
var quiz_ui = null
var quiz_modal = null
var current_answer = 0
var correct_answer = 0
var game_over_ui = null
var is_game_over = false

func _ready():
	vitality_bar.max_value = 100
	vitality_bar.value = 100
	show_quiz_button()
	
	# Connect player death signal
	player.player_died.connect(_on_player_died)

func _process(delta):
	if player and not is_game_over:
		vitality_bar.value = player.vitality
		
		if player.vitality < 30:
			vitality_bar.modulate = Color.RED
		elif player.vitality < 60:
			vitality_bar.modulate = Color.YELLOW
		else:
			vitality_bar.modulate = Color.GREEN

func _on_player_died():
	is_game_over = true
	show_game_over_screen()

func show_game_over_screen():
	# Create game over modal
	game_over_ui = ColorRect.new()
	game_over_ui.color = Color(0, 0, 0, 0.8)  # Dark overlay
	game_over_ui.size = Vector2(1280, 720)
	game_over_ui.position = Vector2.ZERO
	$CanvasLayer/Control.add_child(game_over_ui)
	
	# Game over panel
	var game_over_panel = ColorRect.new()
	game_over_panel.color = Color(0.1, 0.1, 0.1, 1)  # Dark panel
	game_over_panel.size = Vector2(500, 300)
	game_over_panel.position = Vector2(390, 210)
	game_over_ui.add_child(game_over_panel)
	
	# Red border
	var border = ColorRect.new()
	border.color = Color.RED
	border.size = Vector2(510, 310)
	border.position = Vector2(385, 205)
	game_over_ui.add_child(border)
	game_over_ui.move_child(border, 0)
	
	# Game Over title
	var title_label = Label.new()
	title_label.text = "THE PARASITE CONSUMED YOU"
	title_label.position = Vector2(20, 30)
	title_label.add_theme_font_size_override("font_size", 28)
	title_label.add_theme_color_override("font_color", Color.RED)
	game_over_panel.add_child(title_label)
	
	# Subtitle
	var subtitle_label = Label.new()
	subtitle_label.text = "You failed to feed the symbiotic hunger..."
	subtitle_label.position = Vector2(20, 80)
	subtitle_label.add_theme_font_size_override("font_size", 16)
	subtitle_label.add_theme_color_override("font_color", Color.WHITE)
	game_over_panel.add_child(subtitle_label)
	
	# Restart button
	var restart_btn = Button.new()
	restart_btn.text = "RESTART GAME"
	restart_btn.size = Vector2(150, 50)
	restart_btn.position = Vector2(20, 150)
	restart_btn.add_theme_color_override("font_color", Color.WHITE)
	restart_btn.modulate = Color(0.7, 0.2, 0.2, 1)  # Dark red
	restart_btn.pressed.connect(restart_game)
	game_over_panel.add_child(restart_btn)
	
	# Quit button
	var quit_btn = Button.new()
	quit_btn.text = "QUIT"
	quit_btn.size = Vector2(100, 50)
	quit_btn.position = Vector2(200, 150)
	quit_btn.add_theme_color_override("font_color", Color.WHITE)
	quit_btn.modulate = Color(0.3, 0.3, 0.3, 1)  # Gray
	quit_btn.pressed.connect(quit_game)
	game_over_panel.add_child(quit_btn)

func restart_game():
	get_tree().reload_current_scene()

func quit_game():
	get_tree().quit()

func show_quiz_button():
	if quiz_ui == null:
		quiz_ui = Button.new()
		quiz_ui.text = "Get New Resource"
		quiz_ui.size = Vector2(120, 40)
		quiz_ui.position = Vector2(1100, 20)
		quiz_ui.pressed.connect(start_quiz)
		$CanvasLayer/Control.add_child(quiz_ui)

func start_quiz():
	if is_game_over:
		return  # Don't allow quiz during game over
	
	var num1 = randi() % 15 + 1
	var num2 = randi() % 15 + 1
	correct_answer = num1 + num2
	current_answer = 0
	
	show_simple_quiz_modal(str(num1) + " + " + str(num2) + " = ?")

func show_simple_quiz_modal(question: String):
	# Create modal background with semi-transparent overlay
	quiz_modal = ColorRect.new()
	quiz_modal.color = Color(0, 0, 0, 0.6)  # Dark semi-transparent background
	quiz_modal.size = Vector2(1280, 720)
	quiz_modal.position = Vector2.ZERO
	$CanvasLayer/Control.add_child(quiz_modal)
	
	# Create main quiz panel with white background
	var quiz_panel = ColorRect.new()
	quiz_panel.name = "QuizPanel"
	quiz_panel.color = Color.WHITE
	quiz_panel.size = Vector2(450, 300)
	quiz_panel.position = Vector2(415, 210)  # Center on screen
	quiz_modal.add_child(quiz_panel)
	
	# Add border/shadow effect
	var border = ColorRect.new()
	border.color = Color(0.2, 0.2, 0.2, 1)  # Dark gray border
	border.size = Vector2(460, 310)
	border.position = Vector2(410, 205)
	quiz_modal.add_child(border)
	quiz_modal.move_child(border, 0)  # Put border behind panel
	
	# Title
	var title_label = Label.new()
	title_label.text = "MATH CHALLENGE"
	title_label.position = Vector2(20, 15)
	title_label.add_theme_font_size_override("font_size", 20)
	title_label.add_theme_color_override("font_color", Color(0.1, 0.1, 0.8, 1))  # Dark blue
	quiz_panel.add_child(title_label)
	
	# Question text with styling
	var question_label = Label.new()
	question_label.text = question
	question_label.position = Vector2(20, 60)
	question_label.add_theme_font_size_override("font_size", 36)
	question_label.add_theme_color_override("font_color", Color.BLACK)
	quiz_panel.add_child(question_label)
	
	# Answer display with background
	var answer_bg = ColorRect.new()
	answer_bg.color = Color(0.95, 0.95, 0.95, 1)  # Light gray background
	answer_bg.size = Vector2(300, 50)
	answer_bg.position = Vector2(20, 120)
	quiz_panel.add_child(answer_bg)
	
	var answer_label = Label.new()
	answer_label.name = "AnswerLabel"
	answer_label.text = "Your Answer: 0"
	answer_label.position = Vector2(30, 130)
	answer_label.add_theme_font_size_override("font_size", 24)
	answer_label.add_theme_color_override("font_color", Color(0, 0.5, 0, 1))  # Dark green
	quiz_panel.add_child(answer_label)
	
	# Styled instructions
	var help_label = Label.new()
	help_label.text = "Use number keys to enter your answer"
	help_label.position = Vector2(20, 185)
	help_label.add_theme_font_size_override("font_size", 14)
	help_label.add_theme_color_override("font_color", Color(0.4, 0.4, 0.4, 1))  # Gray
	quiz_panel.add_child(help_label)
	
	# Styled buttons
	var submit_btn = Button.new()
	submit_btn.text = "SUBMIT ANSWER"
	submit_btn.size = Vector2(140, 40)
	submit_btn.position = Vector2(20, 220)
	submit_btn.add_theme_color_override("font_color", Color.WHITE)
	submit_btn.modulate = Color(0.2, 0.7, 0.2, 1)  # Green button
	submit_btn.pressed.connect(submit_answer)
	quiz_panel.add_child(submit_btn)
	
	var cancel_btn = Button.new()
	cancel_btn.text = "CANCEL"
	cancel_btn.size = Vector2(100, 40)
	cancel_btn.position = Vector2(180, 220)
	cancel_btn.add_theme_color_override("font_color", Color.WHITE)
	cancel_btn.modulate = Color(0.8, 0.3, 0.3, 1)  # Red button
	cancel_btn.pressed.connect(close_quiz)
	quiz_panel.add_child(cancel_btn)
	
	var clear_btn = Button.new()
	clear_btn.text = "CLEAR"
	clear_btn.size = Vector2(80, 40)
	clear_btn.position = Vector2(300, 220)
	clear_btn.add_theme_color_override("font_color", Color.WHITE)
	clear_btn.modulate = Color(0.5, 0.5, 0.5, 1)  # Gray button
	clear_btn.pressed.connect(clear_answer)
	quiz_panel.add_child(clear_btn)
	
	# Start input handling (without ENTER key)
	handle_input_buttons_only()

func handle_input_buttons_only():
	while quiz_modal != null:
		await get_tree().process_frame
		
		# Exit if modal was closed
		if quiz_modal == null:
			break
		
		# Check number keys 1-9
		for i in range(1, 10):
			if Input.is_action_just_pressed("ui_" + str(i)) or Input.is_key_pressed(KEY_0 + i):
				current_answer = current_answer * 10 + i
				update_answer_display()
				await get_tree().create_timer(0.15).timeout
				break
		
		# Check 0 key
		if Input.is_action_just_pressed("ui_0") or (Input.is_key_pressed(KEY_0) and current_answer > 0):
			current_answer = current_answer * 10
			update_answer_display()
			await get_tree().create_timer(0.15).timeout
		
		# Escape to cancel
		if Input.is_action_just_pressed("ui_cancel"):
			close_quiz()
			break

func update_answer_display():
	if quiz_modal:
		var answer_label = quiz_modal.get_node_or_null("QuizPanel/AnswerLabel")
		if answer_label:
			answer_label.text = "Your Answer: " + str(current_answer)

func clear_answer():
	current_answer = 0
	update_answer_display()

func submit_answer():
	if current_answer == correct_answer:
		show_result("CORRECT! +1 Resource", Color.GREEN)
		spawn_new_resource()
	else:
		show_result("WRONG! Answer was " + str(correct_answer), Color.RED)

func show_result(message: String, color: Color):
	if quiz_modal:
		# Clear existing content completely
		for child in quiz_modal.get_children():
			child.queue_free()
		
		# Wait a frame to ensure children are removed
		await get_tree().process_frame
		
		# Create result panel
		var result_panel = ColorRect.new()
		result_panel.color = Color.WHITE
		result_panel.size = Vector2(400, 200)
		result_panel.position = Vector2(440, 260)
		quiz_modal.add_child(result_panel)
		
		# Add border
		var border = ColorRect.new()
		border.color = Color(0.2, 0.2, 0.2, 1)
		border.size = Vector2(410, 210)
		border.position = Vector2(435, 255)
		quiz_modal.add_child(border)
		quiz_modal.move_child(border, 0)
		
		# Result message
		var result_label = Label.new()
		result_label.text = message
		result_label.position = Vector2(20, 60)
		result_label.add_theme_font_size_override("font_size", 20)
		result_label.add_theme_color_override("font_color", color)
		result_panel.add_child(result_label)
		
		# Always add a "Continue" button that works properly
		var continue_btn = Button.new()
		if color == Color.RED:
			continue_btn.text = "TRY AGAIN"
		else:
			continue_btn.text = "CONTINUE"
		continue_btn.size = Vector2(120, 40)
		continue_btn.position = Vector2(20, 120)
		continue_btn.add_theme_color_override("font_color", Color.WHITE)
		continue_btn.modulate = Color(0.3, 0.3, 0.8, 1)  # Blue button
		continue_btn.pressed.connect(close_quiz)
		result_panel.add_child(continue_btn)
		
		# Auto close after 4 seconds
		await get_tree().create_timer(4.0).timeout
		close_quiz()

func close_quiz():
	if quiz_modal:
		quiz_modal.queue_free()
		quiz_modal = null
	current_answer = 0
	correct_answer = 0

func spawn_new_resource():
	if is_game_over:
		return  # Don't spawn resources during game over
		
	var resource_scene = preload("res://sacrifice_resources.tscn")
	var new_resource = resource_scene.instantiate()
	new_resource.position = Vector2(
		randf_range(-400, 400),
		randf_range(-200, 200)
	)
	add_child(new_resource)
