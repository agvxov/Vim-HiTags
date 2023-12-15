#include <stdio.h>
#include "helper.h"

typedef int myint;

typedef enum {
	ENUMVALUE,
	ENUMEND,
} myenum;

enum enum2 {
	ENUMVALUE2,
	ENUMEND2,
};

typedef union {
	int i,
	char c,
} myunion;

union myunion2 {
	int i,
	char c,
};

// Global variables
int global_var = 10;

myint main() {
    puts("Hello, world!");

    // Call helper function
    helper();

    return 0;
}
