default: run

mock-server:
	docker run -p 8080:80 -v $(shell pwd)/run/server-mock.json:/data/db.json clue/json-server

mock-server-bg:
	docker run -d -p 8080:80 -v $(shell pwd)/run/server-mock.json:/data/db.json clue/json-server

build:
	elm-make Main.elm --output elm.compiled.js --warn

# work directly with elm files
# this allows you to see update history (state changes)
.PHONY: run
run:
	elm-reactor

# watch elm files and recompile js on elm file change
# this allows you to preview the index.html (with styles, etc.)
watch:
	npm run watch
