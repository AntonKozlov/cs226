
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
	const char *msg = "Hello, World!\n";
	const int len = strlen(msg);
	int r = write(1, msg, len);
	printf("%d\n", r);
        return 0;
}

