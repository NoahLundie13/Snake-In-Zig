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

    // Init array w/ empty vec2s
    for (&snakePositions) |*position| {
        position.* = Vector2.init(-5, -5);
    }

    //Set Spawn Pos
    snakePositions[0] = spawnPosition();

    rl.setTargetFPS(60);

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

        rl.clearBackground(rl.Color.white);
    }
}

fn drawSnake() void {
    checkCollisions();

    var i: usize = 0;
    while (i <= tailLength) {
        rl.drawRectangleV(snakePositions[i].multiply(POSITIONSIZE), POSITIONSIZE, rl.Color.black);
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
        const posX: i32 = Rand.intRangeLessThan(i32, 0, 15);
        const posY: i32 = Rand.intRangeLessThan(i32, 0, 15);

        foodPos = Vector2.init(@floatFromInt(posX), @floatFromInt(posY));

        isFoodActive = false;
    }
    rl.drawRectangleV(foodPos.multiply(POSITIONSIZE), POSITIONSIZE, rl.Color.red);
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
}

fn spawnPosition() Vector2 {
    const x = Rand.intRangeLessThan(i32, 3, 22);
    const y = Rand.intRangeLessThan(i32, 3, 22);
    return Vector2.init(@floatFromInt(x), @floatFromInt(y));
}
