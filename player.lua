player = {}

function player:load()
    self.width = map.layers["Spawn Points"].objects[1].width
    self.height = map.layers["Spawn Points"].objects[1].height
    self.x = map.layers["Spawn Points"].objects[1].x
    self.y = map.layers["Spawn Points"].objects[1].y
    
    self.images = {
        love.graphics.newImage("assets/sprite_sheets/player/Biker_idle.png"), 
        love.graphics.newImage("assets/sprite_sheets/player/Biker_run.png"), 
        love.graphics.newImage("assets/sprite_sheets/player/Biker_jump.png"),
        love.graphics.newImage("assets/sprite_sheets/player/Biker_hurt.png"),
        love.graphics.newImage("assets/sprite_sheets/player/Biker_death.png")
    }

    self.grids = {}
    for i, image in ipairs(self.images) do 
        self.grids[i] = anim8.newGrid(self.width, self.height - self.height * 0.25, image:getWidth(), image:getHeight(), 0, self.height * 0.25)
    end
    self.current_image = 1
    self.frames = self.grids[self.current_image]("1-" .. self.images[self.current_image]:getWidth() / self.width, 1)
    self.animation = anim8.newAnimation(self.frames, 0.25)
    
end

function player:update(dt)
    self.animation:update(dt)
end

function player:draw()
    self.animation:draw(self.images[self.current_image], self.x, self.y)
end