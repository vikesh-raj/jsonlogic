.PHONY: test get publish analyze

test:
	flutter pub run test test

get:
	flutter pub get

publish:
	flutter pub publish --dry-run

analyze:
	flutter analyze
