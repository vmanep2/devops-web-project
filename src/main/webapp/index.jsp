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
            margin-bottom: 20px;
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

        #score {
            margin: 15px 0;
            font-size: 24px;
        }
    </style>
</head>
<body>
    <h1>Hello Nak</h1>
    <div id="score">0 : 0</div>
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
        const ballSpeed = 4;

        let ballX = gameWidth / 2 - 7;
        let ballY = gameHeight / 2 - 7;
        let ballDX = ballSpeed;
        let ballDY = ballSpeed;

        let paddleLeftY = gameHeight / 2 - 40;
        let paddleRightY = gameHeight / 2 - 40;

        let keys = {};

        let scoreLeft = 0;
        let scoreRight = 0;

        document.addEventListener("keydown", e => keys[e.key] = true);
        document.addEventListener("keyup", e => keys[e.key] = false);

        function update() {
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

            // Paddle collision
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
                resetBall();
            }
            if (ballX > gameWidth - 15) {
                scoreLeft++;
                resetBall();
            }

            scoreDisplay.textContent = `${scoreLeft} : ${scoreRight}`;

            ball.style.left = ballX + "px";
            ball.style.top = ballY + "px";

            requestAnimationFrame(update);
        }

        function resetBall() {
            ballX = gameWidth / 2 - 7;
            ballY = gameHeight / 2 - 7;
            ballDX *= -1;
            ballDY = (Math.random() > 0.5 ? 1 : -1) * ballSpeed;
        }

        update();
    </script>
</body>
</html>
