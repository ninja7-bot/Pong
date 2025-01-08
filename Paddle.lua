Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dy = 0
end    

function Paddle:update(dt)
    if self.dy < 0 then
        self.dy = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VHEIGHT - self.height, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end     