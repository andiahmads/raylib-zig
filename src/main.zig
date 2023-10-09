const ray = @cImport({
    @cInclude("raylib.h");
});

const Vector2 = ray.Vector2;

pub fn main() void {
    const screenWidth = 800;
    const screenHeight = 450;
    ray.SetConfigFlags(ray.FLAG_MSAA_4X_HINT);

    ray.InitWindow(screenWidth, screenHeight, "RAYLIB [shapes] example - bouncing ball with ZIG");

    // setup to c_int
    const virtualWidth = @as(f32, @floatFromInt(ray.GetScreenWidth()));
    const virtualHeight = @as(f32, @floatFromInt(ray.GetScreenHeight()));

    var ballPosition = ray.Vector2{ .x = virtualWidth / 2.0, .y = virtualHeight / 2.0 };
    var ballSpeed = Vector2{ .x = 4.0, .y = 5.0 };

    const ballRadius = 20;
    var frameCounter: i32 = undefined;

    var pause: bool = undefined;

    defer ray.CloseWindow();
    ray.SetTargetFPS(60);

    while (!ray.WindowShouldClose()) {
        if (ray.IsKeyPressed(ray.KEY_SPACE)) {
            pause = !pause;
        }

        if (!pause) {
            ballPosition.x += ballSpeed.x;
            ballPosition.y += ballSpeed.y;

            // Check walls collision for bouncing
            if (ballPosition.x >= virtualWidth - ballRadius or ballPosition.x <= ballRadius) ballSpeed.x *= -1.0;
            if (ballPosition.y >= virtualHeight - ballRadius or ballPosition.y <= ballRadius) ballSpeed.y *= -1.0;
        } else {
            frameCounter += 1;
        }
        ray.BeginDrawing();
        defer ray.EndDrawing();
        ray.ClearBackground(ray.RAYWHITE);

        ray.DrawCircleV(ballPosition, ballRadius, ray.RED);

        // @rem untuk mendapatkan sisa pembagian.
        if (pause and (@rem(@divTrunc(frameCounter, 30), 2) == 0)) {
            // if (pause and (@divTrunc(frameCounter, 30) % 2)) {
            ray.DrawText("PAUSED", 350, 200, 30, ray.GRAY);
        }

        ray.DrawFPS(10, 10);
    }
    ray.CloseWindow();
}
