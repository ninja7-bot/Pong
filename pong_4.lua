love = require "love"
push = require 'push'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VWIDTH = 432
VHEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- Generating a seed value based on current time.
    math.randomseed(os.time())

    -- Font to be used for the text in the game.
    smallFont = love.graphics.newFont('font.ttf', 8)
    love.graphics.setFont(smallFont)

    -- New Font sizes for the Player Scores.
    scoreFont = love.graphics.newFont('font.ttf', 32)
    
    push:setupScreen(VWIDTH, VHEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { fullscreen = false, resizable = false, vsync = true })

    -- Score track for the players
    p1_score = 0
    p2_score = 0

    --These Y values keep the track of the movements of the Paddles.
    p1_Y = 30
    p2_Y = VHEIGHT - 50


    -- ballX and ballY are the random values of X and Y to place the ball at.
    ballX = VHEIGHT / 2 - 2
    ballY = VWIDTH / 2 - 2

    -- ballDX and ballDY are the velocities of the ball at X and Y coordinates.
    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    gameState = 'start'
end

function love.update(dt)
    -- This is the main game loop. It is called every frame.
    -- Here, we can update the game state, and also check for collisions.
    if love.keyboard.isDown('w') then --signifies the paddle moving up for player 1
        p1_Y = math.max(0, p1_Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then --signifies the paddle moving down for player 1
        p1_Y = math.min(VHEIGHT - 20, p1_Y + PADDLE_SPEED * dt)
    end
    
    if love.keyboard.isDown('up') then --signifies the paddle moving up for player 2
        p2_Y = math.max(0, p2_Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then --signifies the paddle moving down for player 2
        p2_Y = math.min(VHEIGHT - 20, p2_Y + PADDLE_SPEED * dt)
    end

    if gameState == 'play' then -- At the gameState play, the ball's movement starts.
        ballX = ballX + ballDX * dt -- this decides the position at X coordinate.
        ballY = ballY + ballDY * dt -- this decides the position at Y coordinate.
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'  
            -- Reinitialize the ball at the center.
            ballX = VWIDTH / 2 - 2
            ballY = VHEIGHT / 2 - 2

            -- Initialize the ball's movements.
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end

function love.draw() --Rendering

    push:apply('start')

    -- Setting a color to the background. Grey, here.
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf('Welcome to PONG!', 0, 20, VWIDTH, 'center')
    else 
        love.graphics.printf('PONG Play State!', 0, 20, VWIDTH, 'center')
    end

    -- Creating the two paddles.
    love.graphics.rectangle('fill', 10, p1_Y, 5, 20) -- paddle 1 now moves based on p1_y
    love.graphics.rectangle('fill', VWIDTH - 10 , p2_Y, 5, 20) -- paddle 2 now moves based on p2_Y
    
    love.graphics.rectangle('fill', ballX, ballY, 5, 5) -- ball
    
    push:apply('end')
end
