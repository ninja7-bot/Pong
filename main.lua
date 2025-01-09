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

    love.window.setTitle('PONG! By Dark Samurai')
    -- Font to be used for the text in the game.

    -- Generating a seed value based on current time.
    math.randomseed(os.time())  

    smallFont = love.graphics.newFont('font.ttf', 8)

    winFont = love.graphics.newFont('font.ttf', 24)
    -- New Font sizes for the Player Scores.
    scoreFont = love.graphics.newFont('font.ttf', 32)

    sounds = {
        ["paddle_hit"] = love.audio.newSource('Sounds/paddle_hit.wav', 'static'),
        ["score"] = love.audio.newSource('Sounds/score.wav', 'static'),
        ["wall_hit"] = love.audio.newSource('Sounds/wall_hit.wav', 'static')
    }
    
    love.graphics.setFont(smallFont)
    push:setupScreen(VWIDTH, VHEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { fullscreen = false, resizable = true, vsync = true })

    p1_score = 0
    p2_score = 0

    servingPlayer = 1
    
    -- Instantiate Player Paddles.
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VWIDTH - 10, VHEIGHT - 30, 5, 20)
    
    -- Instantiate ball.
    ball = Ball(VWIDTH/2-2, VHEIGHT/2-2, 5, 5)

    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end    

function love.update(dt)
    if gameState == 'serving' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(150, 200)
        else
            ball.dx = -math.random(150, 200)
        end
    elseif gameState == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.10
            ball.x = player1.x + 5

            if ball.dy < 0  then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10,150)
            end
            sounds['paddle_hit']:play()
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.10
            ball.x = player2.x - 5

            if ball.dy > 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end
        if ball.y <= 5 then 
            ball.y = 5
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
        if ball.y >= VHEIGHT - 9 then
            ball.y = VHEIGHT - 9
            ball.dy = - ball.dy
            sounds['wall_hit']:play()
        end

        if ball.x < 0 then
            servingPlayer = 1
            p2_score = p2_score + 1
            sounds['score']:play()
    
            if p2_score == 10 then
                winPlayer = 2
                gameState = 'win'
            else
                gameState = 'serving'
                ball:reset()
            end
        end
    
        if ball.x > VWIDTH then
            servingPlayer = 2
            p1_score = p1_score + 1
            sounds['score']:play()
    
            if p1_score == 10 then
                winPlayer = 1
                gameState = 'win'
            else
                gameState = 'serving'
                ball:reset()
            end
        end
    end

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
        player2.dy = 0
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
    elseif key == 'return' or key == 'space' then
        if gameState == 'start' then
            gameState = 'serving'
        elseif gameState == 'serving' then
            gameState = 'play'  

        elseif gameState == 'win' then
            gameState = 'serving'
            
            ball:reset()

            p1_score = 0
            p2_score = 0

            if winPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

function love.draw() --Rendering

    push:apply('start')

    -- Setting a color to the background. Grey, here.
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(smallFont)
    displayScore()

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to PONG!', 0, 10, VWIDTH, 'center')
        love.graphics.printf('Press Space to begin!', 0, 20, VWIDTH, 'center')
    elseif gameState == 'serving' then  
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s Serve!", 0, 10, VWIDTH, 'center')
        love.graphics.printf('Press Space to Serve!', 0, 20, VWIDTH, 'center')
    elseif gameState == 'play' then

    elseif gameState == 'win' then
        love.graphics.setFont(winFont)
        love.graphics.printf('Player ' .. tostring(winPlayer) .. ' Wins!', 0, 10, VWIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Space to Restart!', 0, 30, VWIDTH, 'center')
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

function displayScore()
    -- draw score on the left and right center of the screen
    -- need to switch font to draw before actually printing
    --[[
    love.graphics.setFont(smallFont)
    love.graphics.print('Player 1', 75, 25)
    love.graphics.print('Player 2', VWIDTH - 100, 25)
    ]]
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(p1_score), VWIDTH / 2 - 50, 
        VHEIGHT / 3)
    love.graphics.print(tostring(p2_score), VWIDTH / 2 + 30,
        VHEIGHT / 3)
end