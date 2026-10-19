CC = gcc
CFLAGS = -Wall -Wextra -O3 -std=c11

.PHONY: build test lint clean

build:
	$(CC) $(CFLAGS) prime_utils.c test_app.c -o validator

test: build
	./validator

# System headers are supplied by GCC. Cppcheck checks our source files.
lint:
	cppcheck --enable=all --error-exitcode=1 --suppress=missingIncludeSystem prime_utils.c test_app.c

clean:
	rm -f validator validator.exe *.tar.gz
