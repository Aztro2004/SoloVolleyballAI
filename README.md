# Volleyball Robot AI Trainer

A Godot 4 implementation of a solo volleyball robot that learns to keep a ball in play using deep reinforcement learning.


## Features

- **Physics-based volleyball mechanics**
  - RigidBody3D ball
- **AI controller with observation space**:
  - cube position (x,y,z).
  - ball position (x,y,z).
  - Relative position from cube to ball (only x and z axis to not penalize ball height).
  
      
## Rewards
**Positive**
- Keeping the ball alive
- Hitting the ball
- height of the ball.


**Negative**
- Letting the ball die.
- Not doing anything.
- gluing itself to walls.

## Action Spaxe
- Moving in x,z axis
- Jumping.

## Example of training

the num_iterations is in the indicated on the title of the video



https://github.com/user-attachments/assets/43fe1a01-0204-428d-8ef3-de874057b341

https://github.com/user-attachments/assets/92995171-d803-4763-9a73-c65bbaac48db

https://github.com/user-attachments/assets/e09f833e-244c-49ca-9552-ea0a06d5affd

https://github.com/user-attachments/assets/6c66aa59-aa41-44bd-ba08-10fc79fad36e

https://github.com/user-attachments/assets/a75ae3f8-312f-4af8-9117-f0e22dc5b269

https://github.com/user-attachments/assets/17986368-dd97-43e0-974f-711f2c404b68





## Bonus Clips

### When the AI got the ball stuck in the air for infinite points

https://github.com/user-attachments/assets/db58b04b-2d00-432c-86b0-e2d73e20f238

### Boring solution the AI came up with before fine-tuning it

https://github.com/user-attachments/assets/5731ba9d-e6fd-4010-ba6c-4857b0042d0b

## Dependencies

- Godot: https://github.com/godotengine/godot

- Godot RL: https://github.com/edbeeching/godot_rl_agents_plugin

## References

- Basic tutorial: [https://github.com/godotengine/godot](https://www.youtube.com/watch?v=f8arMv_rtUU)



