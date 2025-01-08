love = require "love"
push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'

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

    -- Instantiate Player Paddles.
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VWIDTH - 10, VHEIGHT - 30, 5, 20)

    -- Instantiate ball.
    ball = Ball(VWIDTH/2-2, VHEIGHT/2-2, 5, 5)

    gameState = 'start'
end

function love.update(dt)
    -- This is the main game loop. It is called every frame.
    -- Here, we can update the game state, and also check for collisions.
    if love.keyboard.isDown('w') then --signifies the paddle moving up for player 1
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then --signifies the paddle moving down for player 1
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end
    
    if love.keyboard.isDown('up') then --signifies the paddle moving up for player 2
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then --signifies the paddle moving down for player 2
        player2.dy = PADDLE_SPEED
    else 
        player1.dy = 0
    end

    if gameState == 'play' then -- At the gameState play, the ball's movement starts.
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'  
            
            ball:reset()
        end
    end
end

function love.draw() --Rendering

    push:apply('start')

    love.window.setTitle('PONG! By Dark Samurai')
    -- Setting a color to the background. Grey, here.
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf('Welcome to PONG!', 0, 20, VWIDTH, 'center')
    else 
        love.graphics.printf('PONG Play State!', 0, 20, VWIDTH, 'center')
    end

    -- Creating the two paddles.
    player1:render()
    player2:render()
    
    ball:render()
    
    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: '.. tostring(love.timer.getFPS()), 10, 10)
end    