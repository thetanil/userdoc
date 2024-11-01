#include <stdio.h>
#include <stdlib.h>

int main() {
    asm("outb %0, %1" : : "a"(0x00), "Nd"(0x501));  // Replace 0x00 with an exit code if needed
    return 0;
}
