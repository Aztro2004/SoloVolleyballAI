# Volleyball Robot AI Trainer

A Godot 4 implementation of a solo volleyball robot that learns to keep a ball in play using deep reinforcement learning.


## Features

- **Physics-based volleyball mechanics**
  - RigidBody3D ball
- **AI controller with observation space**:
  - cube position (x,y,z)
  - ball position (x,y,z)
  - ball velocity (x,y,z)
  - position of cube relatively to wall
    
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



https://github.com/user-attachments/assets/8080cd53-f2ed-4f54-bfdb-d4ba8dc4e415

https://github.com/user-attachments/assets/00fd8d6b-b278-4e9a-9140-e770d2639f76

https://github.com/user-attachments/assets/66caee3f-f050-460b-b78e-0fcdf5f78e9d

https://github.com/user-attachments/assets/b482d1ac-13ae-460c-914b-5cedb1e77b4f

## Dependencies

- Godot: https://github.com/godotengine/godot

- Godot RL: https://github.com/edbeeching/godot_rl_agents_plugin

## References

- Godot Engine: https://github.com/godotengine/godot



