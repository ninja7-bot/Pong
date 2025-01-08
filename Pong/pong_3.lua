love = require "love"
push = require 'push'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VWIDTH = 432
VHEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
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
end

function love.update(dt)
    -- This is the main game loop. It is called every frame.
    -- Here, we can update the game state, and also check for collisions.
    if love.keyboard.isDown('w') then --signifies the paddle moving up for player 1
        p1_Y = p1_Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then --signifies the paddle moving down for player 1
        p1_Y = p1_Y + PADDLE_SPEED * dt
    end
    
    if love.keyboard.isDown('up') then --signifies the paddle moving up for player 2
        p2_Y = p2_Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then --signifies the paddle moving down for player 2
        p2_Y = p2_Y + PADDLE_SPEED * dt
    end
end

function love.draw() --Rendering

    push:apply('start')

    -- Setting a color to the background. Grey, here.
    -- love.graphics.clear(40, 45, 52, 255)

    love.graphics.printf(
        'Welcome to PONG!', -- This is the text which is to be printed.
        0, -- this is the X Co-ordinate
        20, -- this is the Y Co-ordinate
        VWIDTH, -- this refers to the number of pixels to align in.
        'center' -- this is the mode of alignment. Can be right, left and center.
    )

    love.graphics.setFont(scoreFont)
    love.graphics.print(
        tostring(p1_score), -- This is the text which is to be printed.
        VWIDTH/2 - 50,
        VHEIGHT/3
    )
    love.graphics.print(
        tostring(p2_score), -- This is the text which is to be printed.
        VWIDTH/2 + 30,
        VHEIGHT/3
    )
    -- Creating the two paddles.
    love.graphics.rectangle('fill', 10, p1_Y, 5, 20) -- paddle 1 now moves based on p1_y
    love.graphics.rectangle('fill', VWIDTH - 10 , p2_Y, 5, 20) -- paddle 2 now moves based on p2_Y
    love.graphics.rectangle('fill', VWIDTH / 2 - 2, VHEIGHT / 2 - 2, 5, 5) -- ball
    
    push:apply('end')
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
