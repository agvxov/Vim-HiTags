#include <iostream>
#include "helper.h"

struct Msg{
	const char* m = "Helper function called!";
} msg;

void helper() {
    std::cout << msg.m << std::endl;
}
