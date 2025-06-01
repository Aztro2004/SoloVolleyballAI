# Volleyball Robot AI Trainer

A Godot 4 implementation of a solo volleyball robot that learns to keep a ball in play using deep reinforcement learning.


## Features

- **Physics-based volleyball mechanics**
  - RigidBody3D ball
- **AI controller with observation space**:
  - cube position (x,y,z).
  - ball position (x,y,z).
  - Relative position from cube to ball.
  
      
## Rewards
**Positive**
- Keeping the ball alive
- Hitting the ball
- Maximum height of ball.


**Negative**
- Letting the ball die.
- Not doing anything.
- gluing itself to walls.

## Action Spaxe
- Moving in x,z axis
- Jumping.

## Example of training


## Bonus Clip of when the AI got the ball stuck in the air for infinite points

https://github.com/user-attachments/assets/db58b04b-2d00-432c-86b0-e2d73e20f238

## Dependencies

- Godot: https://github.com/godotengine/godot

- Godot RL: https://github.com/edbeeching/godot_rl_agents_plugin

## References

- Basic tutorial: [https://github.com/godotengine/godot](https://www.youtube.com/watch?v=f8arMv_rtUU)



