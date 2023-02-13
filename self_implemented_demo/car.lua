-- Car class
car = {
    image = love.graphics.newImage("assets/car2.png"),
}

function car:load()
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = map.tile_width * map.width - self.width
    self.y = (map.height * map.tile_height) - (map.tile_height * 2) - self.height
end

function car:update()
    car:check_collision(player)
end

function car:draw()
    love.graphics.draw(self.image, self.x, self.y, 0 , 1.25, 1.25)
end

function car.check_collision(self, obj)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y 
    local obj_bottom = obj.y + obj.height 

    if  self_right > obj_left
    and self_left < obj_right
    and self_bottom > obj_top
    and self_top < obj_bottom 
    then
        print("Touching car")
    end
end