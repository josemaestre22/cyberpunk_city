player = {}

function player:load()
    self.width = map.layers["Spawn Points"].objects[1].width
    self.height = map.layers["Spawn Points"].objects[1].height
    self.x = map.layers["Spawn Points"].objects[1].x
    self.y = map.layers["Spawn Points"].objects[1].y

    self.frame_width = 48
    self.frame_height = 48
    self.top_blank_space = 14
    self.right_blank_space = 24

    self.scale_y = self.height / (self.frame_height - self.top_blank_space)
    self.scale_x = self.width / (self.frame_width - self.right_blank_space)
    
    self.images = {
        love.graphics.newImage("assets/sprite_sheets/player/Biker_idle.png"), 
        love.graphics.newImage("assets/sprite_sheets/player/Biker_run.png"), 
        love.graphics.newImage("assets/sprite_sheets/player/Biker_jump.png"),
        love.graphics.newImage("assets/sprite_sheets/player/Biker_hurt.png"),
        love.graphics.newImage("assets/sprite_sheets/player/Biker_death.png")
    }

    self.grids = {}
    for i, image in ipairs(self.images) do 
        self.grids[i] = anim8.newGrid(self.frame_width, self.frame_height - self.top_blank_space, image:getWidth(), image:getHeight(), 0, self.top_blank_space)
    end
    self.current_image = 1
    self.frames = self.grids[self.current_image]("1-" .. self.images[self.current_image]:getWidth() / self.frame_width, 1)
    self.animation = anim8.newAnimation(self.frames, 0.25)
    
end

function player:update(dt)
    self.animation:update(dt)
end

function player:draw()
    self.animation:draw(self.images[self.current_image], self.x, self.y, 0, self.scale_x, self.scale_y)
end