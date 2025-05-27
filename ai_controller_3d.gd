extends AIController3D
class_name SoloVolleyballAIController

@onready var ball = $"../../Ball"
@onready var cube = $".."

const FLOOR_HEIGHT = 1.0 
var steps_since_last_hit = 0
var last_ball_height = 0.0
var max_ball_height = 0.0
var ball_vel = ball.linear_velocity


const COURT_LEFT_X = -10.0
const COURT_RIGHT_X = 10.0
const COURT_BACK_Z = -10.0
const COURT_FRONT_Z = 10.0

@onready var walls = $"../../Walls"
@onready var walls_2 = $"../../Walls2"
@onready var walls_3 = $"../../Walls3"
@onready var walls_4 = $"../../Walls4"



var move = Vector2.ZERO  # XZ movement
var jump = false         # Whether jump is requested this frame


func get_obs() -> Dictionary:
	return {
		"obs": [
			# Cube position
			cube.position.x,
			cube.position.z,
			cube.position.y,
			# Ball position
			ball.position.x,
			ball.position.z,
			ball.position.y,
			# Ball velocity
			ball_vel.x, 
			ball_vel.z, 
			ball_vel.y,
			# Distance to walls
			cube.position.distance_to(walls.global_position),
			cube.position.distance_to(walls_2.global_position),
			cube.position.distance_to(walls_3.global_position),
			cube.position.distance_to(walls_4.global_position)

		]
	}

func reset_environment():
	ball.global_position = Vector3(0,15,0)
	ball.linear_velocity = Vector3.ZERO
	ball.angular_velocity = Vector3.ZERO
	cube.global_position = Vector3(0,1,0)
	cube.velocity = Vector3.ZERO
	ball.sleeping = false
	max_ball_height = ball.global_position.y
	steps_since_last_hit = 0


func get_reward() -> float:
	reward = 0.0

	# Reward for keeping the ball alive
	if ball.global_position.y > FLOOR_HEIGHT:
		reward += 0.1
	else:
		reward -= 100.0
		reset_environment()

	# Reward for a hit
	if cube.hit_cooldown_timer == cube.hit_cooldown:
		reward += 10.0

	# Inactivity penalty
	steps_since_last_hit += 1
	if steps_since_last_hit > 300:
		reward -= 0.5
		reset_environment()

	# Max height bonus
	max_ball_height = max(max_ball_height, ball.global_position.y)
	reward += max_ball_height * 0.05

	# Proximity to walls penalty
	var wall_penalty = 0.0
	wall_penalty += 1.0 / (cube.position.distance_to(walls.global_position) + 0.1)
	wall_penalty += 1.0 / (cube.position.distance_to(walls_2.global_position) + 0.1)
	wall_penalty += 1.0 / (cube.position.distance_to(walls_3.global_position) + 0.1)
	wall_penalty += 1.0 / (cube.position.distance_to(walls_4.global_position) + 0.1)
	reward -= wall_penalty * 0.05  # You can tune this scaling factor

	return reward



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
