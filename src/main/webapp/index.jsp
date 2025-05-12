<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pong Game</title>
    <style>
        body {
            background-color: #000;
            color: white;
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }

        h1 {
            margin-bottom: 10px;
        }

        #score {
            margin: 10px 0;
            font-size: 24px;
        }

        #controls {
            margin-bottom: 10px;
        }

        #game {
            position: relative;
            background: #111;
            width: 600px;
            height: 400px;
            border: 3px solid white;
        }

        .paddle {
            position: absolute;
            width: 10px;
            height: 80px;
            background: white;
        }

        #paddleLeft {
            left: 0;
        }

        #paddleRight {
            right: 0;
        }

        #ball {
            position: absolute;
            width: 15px;
            height: 15px;
            background: white;
            border-radius: 50%;
        }

        button {
            margin: 0 5px;
            padding: 6px 12px;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <h1>Hey Will how's your day</h1>
    <div id="score">0 : 0</div>

    <div id="controls">
        <button onclick="startGame()">Start</button>
        <button onclick="pauseGame()">Pause</button>
        <button onclick="resetGame()">Play Again</button>
    </div>

    <div id="game">
        <div id="paddleLeft" class="paddle"></div>
        <div id="paddleRight" class="paddle"></div>
        <div id="ball"></div>
    </div>

    <script>
        const game = document.getElementById("game");
        const ball = document.getElementById("ball");
        const paddleLeft = document.getElementById("paddleLeft");
        const paddleRight = document.getElementById("paddleRight");
        const scoreDisplay = document.getElementById("score");

        const gameWidth = 600;
        const gameHeight = 400;
        const paddleSpeed = 6;
        const baseBallSpeed = 4;

        let ballX, ballY, ballDX, ballDY;
        let paddleLeftY, paddleRightY;
        let keys = {};
        let scoreLeft = 0;
        let scoreRight = 0;
        let isRunning = false;
        let animationFrame;
        let waiting = false;

        document.addEventListener("keydown", e => keys[e.key] = true);
        document.addEventListener("keyup", e => keys[e.key] = false);

        function update() {
            if (!isRunning || waiting) return;

            // Move paddles
            if (keys["w"] && paddleLeftY > 0) paddleLeftY -= paddleSpeed;
            if (keys["s"] && paddleLeftY < gameHeight - 80) paddleLeftY += paddleSpeed;
            if (keys["ArrowUp"] && paddleRightY > 0) paddleRightY -= paddleSpeed;
            if (keys["ArrowDown"] && paddleRightY < gameHeight - 80) paddleRightY += paddleSpeed;

            paddleLeft.style.top = paddleLeftY + "px";
            paddleRight.style.top = paddleRightY + "px";

            // Move ball
            ballX += ballDX;
            ballY += ballDY;

            // Bounce off top/bottom
            if (ballY <= 0 || ballY >= gameHeight - 15) ballDY *= -1;

            // Paddle collisions
            if (ballX <= 10 && ballY + 15 > paddleLeftY && ballY < paddleLeftY + 80) {
                ballDX *= -1;
                ballX = 10;
            }
            if (ballX >= gameWidth - 25 && ballY + 15 > paddleRightY && ballY < paddleRightY + 80) {
                ballDX *= -1;
                ballX = gameWidth - 25;
            }

            // Scoring
            if (ballX < 0) {
                scoreRight++;
                scoreDisplay.textContent = `${scoreLeft} : ${scoreRight}`;
                delayedResetBall();
            }
            if (ballX > gameWidth - 15) {
                scoreLeft++;
                scoreDisplay.textContent = `${scoreLeft} : ${scoreRight}`;
                delayedResetBall();
            }

            ball.style.left = ballX + "px";
            ball.style.top = ballY + "px";

            animationFrame = requestAnimationFrame(update);
        }

        function resetPositions() {
            paddleLeftY = gameHeight / 2 - 40;
            paddleRightY = gameHeight / 2 - 40;
            paddleLeft.style.top = paddleLeftY + "px";
            paddleRight.style.top = paddleRightY + "px";

            ballX = gameWidth / 2 - 7;
            ballY = gameHeight / 2 - 7;
            ball.style.left = ballX + "px";
            ball.style.top = ballY + "px";
        }

        function delayedResetBall() {
            isRunning = false;
            waiting = true;
            resetPositions();
            setTimeout(() => {
                ballDX = (Math.random() > 0.5 ? 1 : -1) * baseBallSpeed;
                ballDY = (Math.random() > 0.5 ? 1 : -1) * baseBallSpeed;
                isRunning = true;
                waiting = false;
                update();
            }, 2000);
        }

        function startGame() {
            if (isRunning) return;
            resetPositions();
            delayedResetBall();
        }

        function pauseGame() {
            isRunning = false;
            cancelAnimationFrame(animationFrame);
        }

        function resetGame() {
            pauseGame();
            scoreLeft = 0;
            scoreRight = 0;
            scoreDisplay.textContent = "0 : 0";
            resetPositions();
            startGame();
        }
    </script>
</body>
</html>
