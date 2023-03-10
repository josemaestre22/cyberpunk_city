--Player object
player = {}

function player.load(self)
    self.images = {
        love.graphics.newImage("assets/sprite_sheets/player/Biker_idle.png"), 
        love.graphics.newImage("assets/sprite_sheets/player/Biker_run.png"), 
        love.graphics.newImage("assets/sprite_sheets/player/Biker_jump.png"),
        love.graphics.newImage("assets/sprite_sheets/player/Biker_hurt.png"),
        love.graphics.newImage("assets/sprite_sheets/player/Biker_death.png")
    }
    
    -- Dimensions of each indiviual character movement image in the sprite sheet
    self.width = 48
    self.height = 48
    
    -- Each of the animation frames in the sprite_sheet
    self.animation_frames = {}
    
    -- Player scale  and offset variables used to make the character bigger and to flip it using negative x scale values and changing offset to half its width
    self.scale_x = 2
    self.scale_y = 2
    self.offset = 0
    
    -- Variables to determine the current image and frame of that image in each animation
    self.current_frame = 1
    self.current_image = 1
    
    -- Player positional and movement variables  
    self.x = 0
    self.y = (map.height * map.tile_height) - (self.height * self.scale_y) - (map.tile_height * 4) --map height in pixels, player height in pixels, player position in pixels.
    self.speed = 200
    self.y_velocity = 0
    self.gravity = 15
    self.ground = self.y + (self.height * self.scale_y)
    self.current_tile = math.floor((self.y + self.height  * self.scale_y) / map.tile_height) * map.width + math.floor((self.x / map.tile_width + 1))
    self.cam_x = 0 -- Camera x-axis position
    -- Player previous positions used in collition detection
    self.last_x = self.x
    self.last_y = self.y
    -- Player lives counter
    self.lives = 3
    self.lives_image = love.graphics.newImage("assets/heart-icon.png")
    self:generate_quads()
end

function player.update(self, dt)
    -- Register the player last position before moving 
    self.last_x = self.x
    self.last_y = self.y   
    
    if self.lives > 0 then
        -- Jump implementation 
        if love.keyboard.isDown("up") then
            -- If the player is in the ground
            if self.y + (self.height * self.scale_y) == self.ground then
                -- Change its y velocity to initiate the jump
                self.y_velocity = -400
            end
        end

        -- If the player has initiated the jump
        if self.y_velocity ~= 0 then 
            self:jump_animation(dt)
            
            -- Initiate Jump
            self.y = self.y + self.y_velocity * dt
            
            -- Apply gravity
            self.y_velocity = self.y_velocity + self.gravity  
        end
        
        --Player horizontal movement implementation
        if love.keyboard.isDown("right") then
            if self.y +  (self.height * self.scale_y) == self.ground then
                self:run_animation(dt)
            end
            
            self.scale_x = 2
            self.offset = 0
            self.x = self.x + self.speed * dt
            
        elseif love.keyboard.isDown("left") then
            if self.y +  (self.height * self.scale_y) == self.ground then
                self:run_animation(dt)
            end
            
            self.scale_x = -2
            self.offset = self.width / 2

            if self.x > 0 then
                self.x = self.x - self.speed * dt
            end

        else
            if self.y +  (self.height * self.scale_y) == self.ground then
                self:idle_animation(dt)
            end
        end
    else
        self:death_animation(dt)
    end
    
    self:check_collision()
    self:camera()
end

function player.draw(self)
    love.graphics.draw(self.images[self.current_image], self.animation_frames[math.floor(self.current_frame)], self.x, self.y, 0, self.scale_x, self.scale_y, self.offset, 0)
end

-- Generate quads of all of the animation frames in the sprite_sheets
function player.generate_quads(self)
    for i, image in ipairs(self.images) do
        for j = 0, image:getWidth() / self.width - 1 do
            table.insert(self.animation_frames, love.graphics.newQuad(j * self.width, 0, self.width, self.height, image:getWidth(), image:getHeight()))
        end
    end
end

function player.idle_animation(self, dt)
    self.current_image = 1
    if self.current_frame <= 4 then
        self.current_frame = self.current_frame + 5 * dt
    else
        self.current_frame = 1
    end
end

function player.run_animation(self, dt)
    self.current_image = 2
    if self.current_frame >= 5 and self.current_frame <= 10 then
        self.current_frame = self.current_frame + 10 * dt
    else
        self.current_frame = 5
    end
end

function player.jump_animation(self, dt)
    self.current_image = 3
    if self.current_frame >= 11 and self.current_frame <= 14 then
        self.current_frame = self.current_frame + 7 * dt
    else
        self.current_frame = 11
    end
end

function player.hurt_animation(self, dt)
    self.current_image = 4
    if self.current_frame < 16 then
        self.current_frame = 16
    else
        self.current_frame = 15
    end
end

function player.death_animation(self, dt)
    self.current_image = 5
    if self.current_frame >= 17 and self.current_frame < 22 then
        self.current_frame = self.current_frame + 5 * dt
        
    elseif math.floor(self.current_frame) == 22 then
        self.current_frame = 22
        
    else
        self.current_frame = 17
    end
end

-- Player collision detection with map
function player.check_collision(self)
    -- Update current tile position
    self.current_tile = math.floor((self.y + self.height  * self.scale_y) / map.tile_height) * map.width + math.floor((self.x / map.tile_width + 1))
    
    -- Tile based ground collision detection
    if map.tile_map[self.current_tile] ~= 0 and self.y_velocity ~= 0 then
        self.ground = math.floor(self.current_tile / map.width) * map.tile_height
        self.y = self.ground - (self.height * self.scale_y)
        self.y_velocity = 0
        
    end
    
    -- Ramp collision detection
    if map.tile_map[self.current_tile + 1] == 0 and self.y_velocity == 0 then
        self.y = self.y + map.tile_height
        self.ground = self.y + (self.height * self.scale_y)
    elseif map.tile_map[self.current_tile - map.width + 1] ~= 0 then
        self.y = self.y - map.tile_height
        self.ground = self.y + (self.height * self.scale_y)
    end
    
    --Player map borders collision detection (Need to fix in cases the player is moving)
    if self.x <= 0 then 
        self.x = 0
    elseif self.x + self.width > (map.width * map.tile_width) then
        self.x = (map.width * map.tile_width) - self.width
    end
end 

-- Player camera implementation
function player.camera(self)
    -- If the x-axis position of the player is more than the middle of the screen
    if self.x > love.graphics.getWidth() / 2 then
        --Move the camera
        
        --Prevent the camera from going off the right border by checking
        --If the x-axis position of the player is more than the width of the map in pixels minus the right-most half of the map visible to the player
        if self.x > (map.width * map.tile_width) - (love.graphics.getWidth() / 2) then
            self.cam_x = - (map.width * map.tile_width / 2)
            
            -- Else, the camera is not at the rightmost part of the map
        else  
            -- Move the camera x-axis by assigning it the the negative of the current player x-axis position 
            -- so that it moves to the side oposite to the player and add to it the half of the screen width so the player is at the center
            self.cam_x = math.floor(-self.x + love.graphics.getWidth() / 2)
        end
    end
end