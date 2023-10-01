#include <iostream>
#include "helper.h"

typedef int myint;

// Global variables
int global_var = 10;

myint main() {
    std::cout << "Hello, world!" << std::endl;

    // Call helper function
    helper();

    return 0;
}
