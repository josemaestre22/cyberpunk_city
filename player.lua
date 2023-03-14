player = {}

function player:load()
    self.width = map.layers["Player"].objects[1].width
    self.height = map.layers["Player"].objects[1].height
    self.x = map.layers["Player"].objects[1].x
    self.y = map.layers["Player"].objects[1].y 
    
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

    self.lives_image = love.graphics.newImage("assets/heart-icon.png")
    
    self.animations = {}
    
    for i, image in ipairs(self.images) do 
        if i == 5 then
            self.animations[i] = anim8.newAnimation((anim8.newGrid(self.frame_width, self.frame_height - self.top_blank_space, image:getWidth(), image:getHeight(), 0, self.top_blank_space)("1-" .. self.images[i]:getWidth() / self.frame_width, 1)), 0.12, 'pauseAtEnd')
        else
            self.animations[i] = anim8.newAnimation((anim8.newGrid(self.frame_width, self.frame_height - self.top_blank_space, image:getWidth(), image:getHeight(), 0, self.top_blank_space)("1-" .. self.images[i]:getWidth() / self.frame_width, 1)), 0.12)
        end
    end
    
    self.current_animation = 1
    
    self.onGround = true
    self.gravity = 15
    self.vx = 0
    self.vy = self.gravity

    self.lives = 3
    self.name = "Player"
    self.damage_cooldown = 2
    self.death_animation_time = 1
    self.animation_timer = 0
    self.dead = false
    self.sounds = {}
    self.sounds.hurt = love.audio.newSource("assets/Hit_hurt 200 (44).wav", "static")
    self.sounds.jump = love.audio.newSource("assets/Jump 4.wav", "static")
    
    world:add(self, self.x, self.y, self.width, self.height)
end

function player:update(dt)
    if self.lives > 0 then
        
        if self.damage_cooldown < 0.5 then
            self.current_animation = 4
            self.vx = 0
            self.sounds.hurt:play()
        else

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
                
            elseif self.onGround then
                self.current_animation = 1
                self.vx = 0
            end
            
            if love.keyboard.isDown("up") and self.onGround then
                self.sounds.jump:play()
                self.vy = -500
            elseif self.onGround == false then
                self.current_animation = 3
            end
        end
    else
        self.current_animation = 5
        self.vx = 0
        self.animation_timer = self.animation_timer + dt
        if self.animation_timer > self.death_animation_time then
            self.dead = true
        end
    end

    self:move(dt)
    self.animations[self.current_animation]:update(dt)
    self.damage_cooldown = self.damage_cooldown + dt
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
        -- Ground, ceilling and mid-air colission resolutions for jumping
        if cols[i].normal.y == -1 then
            self.onGround = true
        elseif cols[i].normal.y == 1 then
            self.vy = 0
        --Mid-air collision with lateral box case
        elseif i == 1 then
            self.onGround = false
            self.vy = self.vy + self.gravity 
        end

        if (cols[i].other.name == "Enemy" or cols[i].other.name == "Bullet") and self.damage_cooldown > 1 then
            self.lives = self.lives - 1
            self.damage_cooldown = 0
            if cols[i].other.name == "Bullet" then
                world:remove(cols[i].other)
                table.remove(bullets, cols[i].other.bullet_number)
            end
        elseif cols[i].other.name == "Ship" then
            won = true
        end
    end
    
    -- Mid air no collision case 
    if len == 0 then 
        self.onGround = false
        self.vy = self.vy + self.gravity 
    end
end