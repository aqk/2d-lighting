
Each module is a single file that manages a state variable (most often a vector) that is visible to the simulator and the renderer.

silo

cities

enemy_missile
  - create-missile [[pos target_pos]]
  - destroy-missiles

player_missile


-------------

State that is mutated in the frame callback is represented as a Clojure ["atom"](https://clojure.org/reference/atoms)

