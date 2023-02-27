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
    
    self.scale_x = self.width / (self.frame_width - self.right_blank_space)
    self.scale_y = self.height / (self.frame_height - self.top_blank_space)
    self.offset = 0
    
    self.images = {
        love.graphics.newImage("assets/sprite_sheets/player/Biker_idle.png"), 
        love.graphics.newImage("assets/sprite_sheets/player/Biker_run.png"), 
        love.graphics.newImage("assets/sprite_sheets/player/Biker_jump.png"),
        love.graphics.newImage("assets/sprite_sheets/player/Biker_hurt.png"),
        love.graphics.newImage("assets/sprite_sheets/player/Biker_death.png")
    }
    
    self.animations = {}
    
    for i, image in ipairs(self.images) do 
        self.animations[i] = anim8.newAnimation((anim8.newGrid(self.frame_width, self.frame_height - self.top_blank_space, image:getWidth(), image:getHeight(), 0, self.top_blank_space)("1-" .. self.images[i]:getWidth() / self.frame_width, 1)), 0.12)
    end
    
    self.current_animation = 1
    
    self.gravity = 500
    self.vx = 0
    self.vy = 0

    world:add(self, self.x, self.y, self.width, self.height)
end

function player:update(dt)
    if love.keyboard.isDown("right") then
        self.current_animation = 2
        self.scale_x = self.width / (self.frame_width - self.right_blank_space)
        self.offset = 0
        self.vx = 150
        
    elseif love.keyboard.isDown("left") then
        self.current_animation = 2
        self.scale_x = - (self.width / (self.frame_width - self.right_blank_space))
        self.offset = self.right_blank_space
        self.vx = -150

    else
        self.current_animation = 1
        self.vx = 0
    end
    print(self.onGround)
    self:move(dt)
    self.animations[self.current_animation]:update(dt)
end

function player:draw()
    self.animations[self.current_animation]:draw(self.images[self.current_animation], self.x, self.y, 0, self.scale_x, self.scale_y, self.offset)
end

function player:move(dt)
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY)
    self.x, self.y = actualX, actualY
    -- deal with the collisions
    for i=1, len do
        
    end
end