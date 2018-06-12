default: run

build:
	elm-make Main.elm --output elm.compiled.js --warn

# work directly with elm files
# this allows you to see update history (state changes)
run:
	elm-reactor

# watch elm files and recompile js on elm file change
# this allows you to preview the index.html (with styles, etc.)
watch:
	npm run watch
