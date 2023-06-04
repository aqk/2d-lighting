all: \
	out/helins/timer.js \
	out/helins/canvas.js \
	out/missile_command/util.js \
	out/missile_command/pos.js \
	out/missile_command/silo.js \
	out/missile_command/cities.js \
	out/missile_command/player_missile.js \
	out/missile_command/sim.js

out/helins/timer.js: timer.cljs/src/main/helins/timer.cljs
	clj -M --main cljs.main --compile helins.timer

out/helins/canvas.js: canvas.cljs/src/main/helins/canvas.cljs
	clj -M --main cljs.main --compile helins.canvas

out/missile_command/util.js: src/missile_command/util.cljs
	clj -M --main cljs.main --compile missile-command.util

out/missile_command/pos.js: src/missile_command/pos.cljs
	clj -M --main cljs.main --compile missile-command.pos

out/missile_command/silo.js: src/missile_command/silo.cljs
	clj -M --main cljs.main --compile missile-command.silo

out/missile_command/cities.js: src/missile_command/cities.cljs
	clj -M --main cljs.main --compile missile-command.cities

out/missile_command/player_missile.js: src/missile_command/player_missile.cljs
	clj -M --main cljs.main --compile missile-command.player_missile

out/missile_command/sim.js: src/missile_command/sim.cljs
	clj -M --main cljs.main --compile missile-command.sim
