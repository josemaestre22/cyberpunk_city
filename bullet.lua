bullets = {}

-- Bullet class
bullet = {
    image = love.graphics.newImage("Ball2.png"),
    speed = 400,
}

-- Bullet Constructor
function bullet:new(entity)
    object = {}   -- create object
    setmetatable(object, self)
    self.__index = self
    width = self.image:getWidth()
    height = self.image:getHeight()
    object.x = entity.x
    object.y = entity.y + entity.height 
    object.direction = entity.direction
    return object
end

function bullet.update(self, dt, bullet_number)
    if self.x > 0 and self.x < map.width * map.tile_width then
        if self.direction == "left" then
            self.x = self.x - self.speed * dt
        else
            self.x = self.x + self.speed * dt
        end
    else 
        table.remove(bullets, bullet_number)
    end
end

function bullet.draw(self)
    love.graphics.draw(self.image, self.x, self.y)
end
