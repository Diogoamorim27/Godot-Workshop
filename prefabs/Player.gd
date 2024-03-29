extends KinematicBody2D

enum states {RUN, JUMP, DEATH, IDLE, CLIMBING}

const animations = { 0 : "Running", 1 : "Jump", 2 : "Death", 3 : "Idle", 4: "Climbing"}
const RUNNING_SPEED = 70
const AIR_SPEED = 60
const GRAVITY = 9.8 * 10
const JUMP = -55

onready var animation_player : = $AnimationPlayer
onready var sprite : = $Sprite

var coins : = 0 
var movement : = Vector2()
var state
var has_key : = false

func _ready():
	state = states.RUN
	pass 


func _process(delta):
	var input = _get_input_direction()
	match state:
		states.RUN:
			_apply_movement(input, RUNNING_SPEED)
			
			if is_on_floor():
				if input == 0:
					state = states.IDLE
				elif Input.is_action_pressed("ui_accept"):
					_jump()
			else:
				state = states.JUMP
			
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)
		
		states.JUMP:
			_apply_gravity(delta)
			_apply_movement(input, AIR_SPEED)
			
			if is_on_floor():
				if input == 0:
					state = states.IDLE
				else:
					state = states.RUN
			
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)	
		
		states.DEATH:
			_apply_movement(0, 0)
			_apply_gravity(delta)
			
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)
		
		states.IDLE:
			if is_on_floor():
				if input != 0:
					state = states.RUN
				elif Input.is_action_pressed("ui_accept"):
					_jump()
			else:
				state = states.JUMP
				
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)	
		
		states.CLIMBING:
		
			movement.x = input * AIR_SPEED
			movement.y = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))) * AIR_SPEED
			
			print(movement.y)
			
			if Input.is_action_pressed("ui_accept"):
				_jump()
			
			movement = move_and_slide(movement)
	
	
	_handle_animation()
	

func _get_input_direction() -> int:
	return int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
func _apply_movement(input : int, speed : float) -> void:
	movement.x = input * speed
	
func _apply_gravity(delta) -> void:
	movement.y += GRAVITY * delta
	
func _jump() -> void:
	movement.y = JUMP
	pass
	
func _handle_animation() -> void:
	if animation_player.current_animation != animations[state]:
		animation_player.play(animations[state])
	
	if movement.x < 0:
		sprite.flip_h = true
	elif movement.x > 0:
		sprite.flip_h = false

func _on_Fire_body_entered(body):
	if body.name == "Player":
		state = states.DEATH
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_Coin_body_entered(body):
	if body.name == "Player":
		coins += 1



func _on_Ladder_body_entered(body):
	if body.name == "Player":
		state = states.CLIMBING


func _on_Ladder_body_exited(body):
	if body.name == "Player":
		state = states.JUMP



func _on_Key_body_entered(body):
	if body.name == "Player":
		has_key = true
