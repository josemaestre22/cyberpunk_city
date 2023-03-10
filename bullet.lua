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
    if entity.vx > 0 then
        object.x = entity.x + entity.width
    else
        object.x = entity.x - entity.width
    end
    object.y = entity.y + entity.height / 2
    object.vx = entity.vx  * 1.5
    world:add(object, object.x, object.y, object.width, object.height)
    return object
end

function bullet:move(dt, entity, bullet_number)
    local goalX, goalY = self.x + self.vx * dt, self.y
    local actualX, actualY, cols, len = world:move(self, goalX, goalY)
    self.x, self.y = actualX, actualY

    if len > 0 then
        if cols[1].other.name == "Player" then
            player.lives = player.lives - 1
        end
        world:remove(self)
        table.remove(entity.bullets, bullet_number)
    end

end

function bullet:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
end