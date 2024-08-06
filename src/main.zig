const rl = @import("raylib");
const std = @import("std");

const Vector2 = rl.Vector2;
const SNAKESIZE = 576;
const POSITIONSIZE: Vector2 = Vector2.init(25, 25);

const Rand = std.crypto.random;

var isGameOver: bool = true;

var tailLength: u16 = 0;
var speed: Vector2 = Vector2.init(1, 0);

var snakePositions: [SNAKESIZE]Vector2 = undefined;
var canMove: bool = false;
var moveTimer: u16 = 8;

var foodPos = Vector2.init(0, 0);
var isFoodActive: bool = true;

var blinkingText: i32 = 0;

pub fn main() void {
    const screenWidth = 600;
    const screenHeight = 600;

    rl.initWindow(screenWidth, screenHeight, "Snake Game In Zig!");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    resetSnake();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        checkInputs();
        drawSnake();
        spawnFood();
        if (!isGameOver) {
            moveSnake();
        } else if (isGameOver) {
            if (blinkingText <= 60) {
                rl.drawText("Press WASD To Start!", 100, 450, 35, rl.Color.dark_gray);
                blinkingText += 1;
            }
            if (blinkingText > 60) {
                blinkingText += 1;
            }
            if (blinkingText == 90) {
                blinkingText = 0;
            }
        }

        rl.clearBackground(rl.Color.init(171, 204, 154, 100));
    }
}

fn drawSnake() void {
    checkCollisions();

    var i: usize = 0;
    while (i <= tailLength) {
        const rect = rl.Rectangle{
            .x = snakePositions[i].multiply(POSITIONSIZE).x,
            .y = snakePositions[i].multiply(POSITIONSIZE).y,
            .width = POSITIONSIZE.x,
            .height = POSITIONSIZE.x,
        };

        rl.drawRectangleRounded(rect, 0.4, 4, rl.Color.init(40, 40, 48, 160));

        i += 1;
    }
}

fn moveSnake() void {
    if (moveTimer == 8) {
        canMove = true;
        moveTimer = 0;
    } else {
        canMove = false;
        moveTimer += 1;
    }

    if (canMove) {
        for (0..tailLength) |i| {
            snakePositions[tailLength - i] = snakePositions[tailLength - i - 1];
        }
        snakePositions[0] = snakePositions[0].add(speed);
    }
}

fn spawnFood() void {
    if (isFoodActive) {
        var posX: i32 = Rand.intRangeLessThan(i32, 0, 24);
        var posY: i32 = Rand.intRangeLessThan(i32, 0, 24);

        for (&snakePositions) |*position| {
            if ((posX) == @as(i32, @intFromFloat(position.x))) {
                posX = Rand.intRangeLessThan(i32, 0, 15);
            }
            if (posY == @as(i32, @intFromFloat(position.y))) {
                posY = Rand.intRangeLessThan(i32, 0, 15);
            }
        }

        foodPos = Vector2.init(@floatFromInt(posX), @floatFromInt(posY));

        isFoodActive = false;
    }
    const foodRect = rl.Rectangle{ .x = foodPos.multiply(POSITIONSIZE).x, .y = foodPos.multiply(POSITIONSIZE).y, .width = POSITIONSIZE.x, .height = POSITIONSIZE.x };
    rl.drawRectangleRounded(foodRect, 0.4, 4, rl.Color.init(255, 115, 118, 255));
}

fn checkInputs() void {
    if (rl.isKeyPressed(rl.KeyboardKey.key_w)) {
        speed = Vector2.init(0, -1);
        if (isGameOver == true) {
            isGameOver = false;
        }
    }
    if (rl.isKeyPressed(rl.KeyboardKey.key_s)) {
        speed = Vector2.init(0, 1);
        if (isGameOver == true) {
            isGameOver = false;
        }
    }
    if (rl.isKeyPressed(rl.KeyboardKey.key_d)) {
        speed = Vector2.init(1, 0);
        if (isGameOver == true) {
            isGameOver = false;
        }
    }
    if (rl.isKeyPressed(rl.KeyboardKey.key_a)) {
        speed = Vector2.init(-1, 0);
        if (isGameOver == true) {
            isGameOver = false;
        }
    }
}

fn checkCollisions() void {
    //Checks collisions with the food;
    if (rl.checkCollisionRecs(
        rl.Rectangle{ .x = snakePositions[0].multiply(POSITIONSIZE).x, .y = snakePositions[0].multiply(POSITIONSIZE).y, .width = POSITIONSIZE.x, .height = POSITIONSIZE.x },
        rl.Rectangle{ .x = foodPos.multiply(POSITIONSIZE).x, .y = foodPos.multiply(POSITIONSIZE).y, .width = POSITIONSIZE.x, .height = POSITIONSIZE.x },
    )) {
        tailLength += 1;
        isFoodActive = true;
    }
    //Check out Of Bounds
    if (snakePositions[0].x * 25 > 575) {
        isGameOver = true;
        resetSnake();
    }
    if (snakePositions[0].x * 25 < 0) {
        isGameOver = true;
        resetSnake();
    }
    if (snakePositions[0].y * 25 > 575) {
        isGameOver = true;
        resetSnake();
    }
    if (snakePositions[0].y * 25 < 0) {
        isGameOver = true;
        resetSnake();
    }
}

fn spawnPosition() Vector2 {
    const x = Rand.intRangeLessThan(i32, 3, 22);
    const y = Rand.intRangeLessThan(i32, 3, 18);
    return Vector2.init(@floatFromInt(x), @floatFromInt(y));
}

fn resetSnake() void {
    for (&snakePositions) |*position| {
        position.* = Vector2.init(-5, -5);
    }
    snakePositions[0] = spawnPosition();
}
