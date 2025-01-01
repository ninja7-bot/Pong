---@diagnostic disable: undefined-global
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

love = require "love"

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true        
    })
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.printf(
        'Welcome to PONG!', -- This is the text which is to be printed.
        0, -- this is the X Co-ordinate
        WINDOW_HEIGHT / 2 - 20, -- this is the Y Co-ordinate
        WINDOW_WIDTH, -- this refers to the number of pixels to align in.
        'center' -- this is the mode of alignment. Can be right, left and center.
    )
endf