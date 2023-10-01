#include <stdio.h>
#include "helper.h"

typedef int myint;

// Global variables
int global_var = 10;

myint main() {
    puts("Hello, world!");

    // Call helper function
    helper();

    return 0;
}
