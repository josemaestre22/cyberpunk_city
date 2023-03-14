-- List of all bullets in the world
bullets = {}

-- Bullet class
bullet = {
    image = love.graphics.newImage("assets/Ball2.png"),
    scale = 2
}


function bullets:update(dt)
    for i, bullet in ipairs(bullets) do
        bullet.bullet_number = i
        bullet:move(dt)
    end
end

function bullets:draw()
    for i, bullet in ipairs(bullets) do
        bullet:draw()
    end
end

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
    object.name = "Bullet"
    world:add(object, object.x, object.y, object.width * self.scale, object.height * self.scale)
    return object
end

function bullet:move(dt)
    local goalX, goalY = self.x + self.vx * dt, self.y
    local actualX, actualY, cols, len = world:move(self, goalX, goalY)
    self.x, self.y = actualX, actualY

    if len > 0 then
        if cols[1].other.name == "Player" and player.damage_cooldown > 1 then
            player.damage_cooldown = 0
            player.lives = player.lives - 1
        end
        world:remove(self)
        table.remove(bullets, self.bullet_number)
    end

end

function bullet:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
end