
The game state is organized as follows:

Vectors, each entry represents a live object in the game, which can be displayed on-screen.

player_missiles - the missiles you are commanding. They start their lives in a silo.
enemy_missiles - enemy missiles leave a contrail, helping the player visualize their trajectory.
silos - buildings that can launch player_missiles. They have an ammo count. If hit, their ammo count goes to zero.
cities - buildings that cannot fire.

All buildings (silos and cities) may be targeted by enemy missiles.

There are also a few input-only or output-only states that do not have a direct impact on the game simulation:

crosshair_pos - input variable; the target position for the next player_missile
score - output variable; 
