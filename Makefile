.PHONY: test get publish analyze coverage format

test:
	dart run test

coverage:
	dart run test --coverage=./coverage
	flutter pub global activate coverage
	flutter pub global run coverage:format_coverage --packages=.packages --report-on=lib --lcov -o ./coverage/lcov.info -i ./coverage
	genhtml -o ./coverage/report ./coverage/lcov.info

get:
	flutter pub get

publish:
	flutter pub publish --dry-run

analyze:
	flutter analyze

format:
	flutter format .
