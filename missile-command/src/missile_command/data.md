
The game state is organized as follows:

Vectors, each entry represents a live object in the game, which can be displayed on-screen.

* [player_missiles](player_missile.cljs) - the missiles you are commanding. They start their lives in a silo.
* [enemy_missiles](enemy_missile.cljs) - enemy missiles leave a contrail, helping the player visualize their trajectory.
* [silos](silo.cljs) - buildings that can launch player_missiles. They have an ammo count. If hit, their ammo count goes to zero.
* [cities](cities.cljs) - buildings that cannot fire.

All buildings (silos and cities) may be targeted by enemy missiles.

There are also a few input-only or output-only states that do not have a direct impact on the game simulation:

* crosshair_pos - input variable; the target position for the next player_missile
* score - output variable;

