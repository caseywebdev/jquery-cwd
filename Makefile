BIN=node_modules/.bin/
COFFEE=$(BIN)coffee

all: npm compile-lib compile-test

npm:
	npm install
	npm rebuild

compile-join:
	$(COFFEE) -c -j dist/jquery-cwd.js lib

compile-join-w:
	$(COFFEE) -cw -j dist/jquery-cwd.js lib

compile-lib:
	$(COFFEE) -c -o dist lib

compile-lib-w:
	$(COFFEE) -cw -o dist lib

compile-test:
	$(COFFEE) -c -j test/test.js test

compile-test-w:
	$(COFFEE) -cw -j test/test.js test

dev:
	make -j dev-j

dev-j: compile-join-w compile-lib-w compile-test-w

test: all
	open test/test.html

.PHONY: test
