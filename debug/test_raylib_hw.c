#include "raylib.h"

signed main(void) {
    InitWindow(800, 450, "Hello World");
    SetTargetFPS(60);

    while (!WindowShouldClose()) {
      BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawText("Hello, World!", 350, 200, 20, DARKGRAY);
      EndDrawing();
    }

    CloseWindow();
    return 0;
}
