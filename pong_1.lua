love = require "love"
push = require 'push'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VWIDTH = 432
VHEIGHT = 243

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VWIDTH, VHEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { fullscreen = false, resizable = false, vsync = true })
end

function love.draw()
    push:apply('start')
    love.graphics.printf(
        'Welcome to PONG!', -- This is the text which is to be printed.
        0, -- this is the X Co-ordinate
        VHEIGHT / 2 - 20, -- this is the Y Co-ordinate
        VWIDTH, -- this refers to the number of pixels to align in.
        'center' -- this is the mode of alignment. Can be right, left and center.
    )
    push:apply('end')
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

