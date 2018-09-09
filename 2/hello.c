
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
	const char *msg = "Hello, World!\n";
	const int len = strlen(msg);
	write(1, msg, len);
	return 0;
}
