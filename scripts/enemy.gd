extends CharacterBody2D

@export var patrol_point: Node2D;
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

const SPEED = 3000.0
const JUMP_VELOCITY = -400.0
const GRAVITY: int = 100

enum State { Idle, Walk }
var current_state = State;
var number_of_point: int;
var direction: Vector2 = Vector2.LEFT;
var point_positions: Array[Vector2];
var current_point: Vector2;
var current_point_position: int;
var can_walk: bool;

func _ready() -> void:
	if patrol_point != null:
		number_of_point = patrol_point.get_children().size()
		for point in patrol_point.get_children():
			print("global_position", point.global_position);
			print("position", point.position)
			point_positions.append(point.global_position);
		current_point = point_positions[current_point_position]
	else:
		print("No Patrol Point");
	
	current_state = State.Idle;

func _physics_process(delta: float) -> void:
	enemy_grafity(delta);
	enemy_idle(delta);
	enemy_walk(delta);
	
	move_and_slide();
	animate_enemy();
	
func enemy_walk(delta: float) -> void:
	if !can_walk:
		return;
		
	if is_on_floor():
		if abs(position.x - current_point.x) > 0.5:
			velocity.x = direction.x * SPEED * delta;
			current_state = State.Walk;
		else:
			current_point_position += 1;
		
			if current_point_position >= number_of_point:
				current_point_position = 0;
				
			current_point = point_positions[current_point_position];
			
			if current_point.x > position.x:
				direction = Vector2.RIGHT;
			else:
				direction = Vector2.LEFT;
				
			can_walk = false;
			timer.start();
			
		animated_sprite_2d.flip_h = direction.x < 0 
			
	
func enemy_idle(delta: float) -> void:
	if is_on_floor() && !can_walk:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta);
		current_state = State.Idle;
	
func enemy_grafity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta;
		
func animate_enemy():
	if current_state == State.Idle && !can_walk:
		animated_sprite_2d.play("idle")
	if current_state == State.Walk && can_walk:
		animated_sprite_2d.play("run")

func _on_timer_timeout() -> void:
	can_walk = true
