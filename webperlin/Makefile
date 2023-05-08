all: static/demo.js

clean:
	rm -f ./src/*.bs.js ./static/*.js

src/demo.bs.js: src/*.ml
	npm run build

static/demo.js: src/demo.bs.js
	./node_modules/.bin/browserify -o $@ src/main.js
