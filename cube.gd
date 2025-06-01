extends CharacterBody3D
class_name SoloVolleyballCharacter

@export var move_speed: float = 5.0
@export var jump_speed: float = 8.0
@export var gravity: float = 9.8
@export var hit_cooldown: float = 0.5

var ball_position_history: Array[Vector3] = []
const HISTORY_LENGTH := 4

var hit_cooldown_timer: float = 0.0

@onready var ai_controller = $AIController3D
@onready var ball = $"../Ball"

func ball_is_within_hit_range() -> bool:
	

	var max_horizontal_distance = 1.5
	var max_vertical_difference = 1.0

	var to_ball = ball.global_position - global_position
	
	var horizontal_distance = Vector2(to_ball.x, to_ball.z).length()
	var vertical_difference = abs(to_ball.y)

	return horizontal_distance <= max_horizontal_distance and vertical_difference <= max_vertical_difference

func hit_ball():
	var direction = (ball.global_position - global_position).normalized()
	ball.linear_velocity = direction * 10.0 + Vector3.UP * 5.0


func _physics_process(delta):
	# Apply cooldown timer
	hit_cooldown_timer = max(0.0, hit_cooldown_timer - delta)
	if hit_cooldown_timer <= 0.0 and ball_is_within_hit_range():
		hit_ball()
		hit_cooldown_timer = hit_cooldown

	ball_position_history.append(ball.global_position)
	if ball_position_history.size() > HISTORY_LENGTH:
		ball_position_history.pop_front()
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		# Jump input only when grounded
		if ai_controller.jump:
			velocity.y = jump_speed

	# Horizontal movement from controller
	velocity.x = ai_controller.move.x * move_speed
	velocity.z = ai_controller.move.y * move_speed
	
	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision:
		if collision.get_collider().name in ["Walls", "Walls2", "Walls3", "Walls4"]:
			ai_controller.touched_wall = true
