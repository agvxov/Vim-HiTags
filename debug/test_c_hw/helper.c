#include <stdio.h>
#include "helper.h"

struct Msg{
	const char* m;
} msg;

void helper() {
	msg.m = "Helper function called!";
    puts(msg.m);
}
