extends AIController3D
class_name SoloVolleyballAIController

@onready var ball = $"../../Ball"
@onready var cube = $".."

@onready var walls = $"../../Walls"
@onready var walls_2 = $"../../Walls2"
@onready var walls_3 = $"../../Walls3"
@onready var walls_4 = $"../../Walls4"

const FLOOR_HEIGHT = 1.0
const MAX_POS = 20.0
const MAX_VEL = 20.0

var steps_since_last_hit = 0
var max_ball_height = 0.0
var touched_wall = false
var ball_position_history: Array[Vector3] = []

var move = Vector2.ZERO
var jump = false

func _physics_process(_delta):
	ball_position_history.append(ball.global_position)
	if ball_position_history.size() > 4:
		ball_position_history.pop_front()

func get_obs() -> Dictionary:
	var obs: Array[float] = []

	# Normalized cube position
	obs.append(cube.position.x)
	obs.append(cube.position.z)
	obs.append(cube.position.y)

	# Ball position (normalized)
	obs.append(ball.position.x)
	obs.append(ball.position.z)
	obs.append(ball.position.y)

	# Ball velocity
	var ball_velocity = ball.linear_velocity
	obs.append(ball_velocity.x)
	obs.append(ball_velocity.z)
	obs.append(ball_velocity.y)

	# Approximate ball momentum from position history
	if ball_position_history.size() >= 2:
		var delta = ball_position_history[-1] - ball_position_history[-2]
		obs.append(delta.x)
		obs.append(delta.z)
		obs.append(delta.y)
	else:
		obs.append_array([0.0, 0.0, 0.0])

	# Relative position from cube to ball
	var to_ball = ball.global_position - cube.global_position
	obs.append(to_ball.x)
	obs.append(to_ball.z)
	obs.append(to_ball.y)

	# Distances to walls (normalized)
	obs.append(cube.position.distance_to(walls.global_position))
	obs.append(cube.position.distance_to(walls_2.global_position))
	obs.append(cube.position.distance_to(walls_3.global_position))
	obs.append(cube.position.distance_to(walls_4.global_position))

	return { "obs": obs }

func get_reward() -> float:
	var reward = 0.0

	# Ball height
	if ball.global_position.y > FLOOR_HEIGHT:
		var height = clamp(ball.global_position.y - FLOOR_HEIGHT, 0.0, 20.0)
		var height_bonus = (height / 20.0) * 30.0 
		reward += height_bonus
	else:
		reward -= 10.0
		reset_environment()

	# Max height
	max_ball_height = max(max_ball_height, ball.global_position.y)
	reward += max_ball_height * 0.05

	# Reward for a hit
	if cube.hit_cooldown_timer == cube.hit_cooldown:
		reward += 1000.0
		steps_since_last_hit = 0

	# Inactivity penalty
	steps_since_last_hit += 1
	if steps_since_last_hit > 400:
		reward -= 100.0
		reset_environment()

	# Distance to ball bonus
	var cube_pos_2d = Vector2(cube.global_position.x, cube.global_position.z)
	var ball_pos_2d = Vector2(ball.global_position.x, ball.global_position.z)
	var dist = cube_pos_2d.distance_to(ball_pos_2d)
	reward += 2.0 / (dist + 0.1) * 100.0

	# Wall collision penalty
	if touched_wall:
		reward -= 10000.0
		touched_wall = false

	return reward

func reset_environment():
	ball.global_position = Vector3(0, 10, 0)
	ball.linear_velocity = Vector3.ZERO
	ball.angular_velocity = Vector3.ZERO
	cube.global_position = Vector3(0, 1, 0)
	cube.velocity = Vector3.ZERO
	ball.sleeping = false
	max_ball_height = ball.global_position.y
	steps_since_last_hit = 0
	ball_position_history.clear()

func get_action_space() -> Dictionary:
	return {
		"move": {
			"size": 2,
			"action_type": "continuous"
		},
		"jump": {
			"size": 1,
			"action_type": "continuous"
		}
	}

func set_action(action: Dictionary) -> void:
	move.x = clamp(action["move"][0], -1.0, 1.0)
	move.y = clamp(action["move"][1], -1.0, 1.0)
	jump = action["jump"][0] > 0.5
