bullets = {}

-- Bullet class
bullet = {
    image = love.graphics.newImage("assets/Ball2.png"),
    speed = 250
}

-- Bullet Constructor
function bullet:new(entity)
    object = {}   -- create object
    setmetatable(object, self)
    self.__index = self
    object.width = self.image:getWidth()
    object.height = self.image:getHeight()
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
        self:check_collision(player, bullet_number)
    else 
        table.remove(bullets, bullet_number)
    end
end

function bullet.draw(self)
    love.graphics.draw(self.image, self.x, self.y, 0, 2, 2)
end

function bullet.check_collision(self, obj, bullet_number)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y + 20
    local obj_bottom = obj.y + (obj.height * obj.scale_y)

    if  self_right > obj_left
    and self_left < obj_right
    and self_bottom > obj_top
    and self_top < obj_bottom 
    then
        print(self_bottom)
        print(obj_top)
        player.lives = player.lives - 1
        table.remove(bullets, bullet_number)
    end
end