.PHONY: test get

test:
	flutter pub run test test

get:
	flutter pub get

publish:
	flutter pub publish --dry-run