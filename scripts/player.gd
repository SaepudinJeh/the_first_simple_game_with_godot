extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum State { Idle, Run }

const SPEED = 260.0
const JUMP_VELOCITY = -400.0

var current_state;

func _ready() -> void:
	current_state = State.Idle;

func _physics_process(delta: float) -> void:
	player_falling(delta);
	player_idle(delta);
	player_run(delta);

	 #Handle jump.
	player_jump();
	
	move_and_slide()
	
	player_animation()

func player_animation():
	if (current_state == State.Idle):
		animated_sprite_2d.play("idle") 
	elif (current_state == State.Run):
		animated_sprite_2d.play("run")

func player_jump():
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
func player_run(_delta: float):
	var direction = Input.get_axis("ui_left", "ui_right");
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction != 0:
		current_state = State.Run
		animated_sprite_2d.flip_h = false if direction > 0 else true
	
func player_idle(_delta: float):
	if is_on_floor():
		current_state = State.Idle;

func player_falling(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta
