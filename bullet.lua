-- Bullet class
bullet = {
    image = love.graphics.newImage("assets/Ball2.png"),
    scale = 2
}

-- Bullet Constructor
function bullet:new(entity)
    object = {}   -- create object
    setmetatable(object, self)
    self.__index = self
    object.width = self.image:getWidth()
    object.height = self.image:getHeight()
    object.x = entity.x + entity.width
    object.y = entity.y + entity.height / 2
    object.vx = entity.vx + 100
    world:add(object, object.x, object.y, object.width, object.height)
    return object
end

function bullet:move(dt, entity, bullet_number)
    local goalX, goalY = self.x + self.vx * dt, self.y
    local actualX, actualY, cols, len = world:move(self, goalX, goalY)
    self.x, self.y = actualX, actualY
end

function bullet:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, scale, scale)
end