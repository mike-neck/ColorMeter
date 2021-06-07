.DEFAULT_GOAL := build

.PHONY: assemble
assemble:
	@echo "==assemble=="
	swift build --configuration release
	./copy-artifacts.sh

.PHONY: clean
clean:
	@echo "==clean=="
	rm -rf build/
	swift package clean

.PHONY: build
build: clean assemble
