ship = {}

function ship:load()
    self.image = love.graphics.newImage("assets/ship-01.png")
    self.x = map.layers["Ship"].objects[1].x 
    self.y = map.layers["Ship"].objects[1].y 
    self.width = map.layers["Ship"].objects[1].width
    self.height = map.layers["Ship"].objects[1].height
    self.scale_x = self.width / self.image:getWidth()
    self.scale_y = self.height / self.image:getHeight() 
    self.name = "Ship"
end

function ship:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale_x, self.scale_y)
end