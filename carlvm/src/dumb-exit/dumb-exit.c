/*
 * See https://stackoverflow.com/questions/42208228/how-to-automatically-close-the-execution-of-the-qemu-after-end-of-process
 */
 // golfed by mv
 
#include <stdlib.h>
#include <sys/io.h>
#include <unistd.h>

#define SHUTDOWN_PORT 0x604
#define EXIT_PORT     0x501

int main(int argc, char **argv) {
    int status;
    status = argc != 2 ? 0 : atoi(argv[1]);
    ioperm(SHUTDOWN_PORT, !status ? 16 : 8, 1);
    outw(!status ? 0x2000 : status - 1, SHUTDOWN_PORT);
    exit(1);
}