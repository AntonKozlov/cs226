
#include <string.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
	const char *defname = "World";
	const char *pref = "Hello, ";
	const char *suf = "\n";
	write(STDOUT_FILENO, pref, strlen(pref));
	write(STDOUT_FILENO, argv[0], strlen(argv[0]));
	const char *name = argc > 1 ? argv[1] : defname;
	write(STDOUT_FILENO, name, strlen(name));
	write(STDOUT_FILENO, suf, strlen(suf));
	return 0;
}
