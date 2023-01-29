--Player sprite and its animations
player = {}

function player.load(self)
    self.images = {love.graphics.newImage("/sprite_sheets/player/Biker_idle.png"), love.graphics.newImage("sprite_sheets/player/Biker_run.png"), love.graphics.newImage("sprite_sheets/player/Biker_jump.png")}

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
    self:generate_quads()
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

function player.update(self, dt)
    -- Jump implementation
    if love.keyboard.isDown("up") then
        -- If the player is in the ground
        if self.y +  (self.height * self.scale_y) == self.ground then
            -- Change its y velocity to initiate the jump
            self.y_velocity = -400
        end
    end 
    
    -- If the player hasn initiated the jump
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

        -- Ramps Collision detection (COULD IMPROVE BY CHECKING FOR X-AXIS COLLISION)
        if map.tile_map[self.current_tile] == 43 or map.tile_map[self.current_tile] == 44 then
            self.y = self.y + map.tile_height
            self.ground = self.y + (self.height * self.scale_y)
        end

        if map.tile_map[self.current_tile - map.width] == 45 or map.tile_map[self.current_tile - map.width] == 46 then
            self.y = self.y - map.tile_height
            self.ground = self.y + (self.height * self.scale_y)
        end

    elseif love.keyboard.isDown("left") then
        if self.y +  (self.height * self.scale_y) == self.ground then
            self:run_animation(dt)
        end
        self.scale_x = -2
        self.offset = self.width / 2
        self.x = self.x - self.speed * dt
        
        -- Ramps Collision detection (COULD IMPROVE BY CHECKING FOR X-AXIS)
        if map.tile_map[self.current_tile - map.width] == 43 or map.tile_map[self.current_tile - map.width] == 4 then
            self.y = self.y - map.tile_height
            self.ground = self.y + (self.height * self.scale_y)
        end

        if map.tile_map[self.current_tile] == 45 or map.tile_map[self.current_tile] == 46 then
            self.y = self.y + map.tile_height
            self.ground = self.y + (self.height * self.scale_y)
        end

    else
        if self.y +  (self.height * self.scale_y) == self.ground then
            player:idle_animation(dt)
        end
    end

    self.current_tile = math.floor((self.y + self.height  * self.scale_y) / map.tile_height) * map.width + math.floor((self.x / map.tile_width + 1))

    -- Tile based ground collision detection
    if map.tile_map[self.current_tile] ~= 0 and self.y_velocity ~= 0 then
        self.ground = math.floor(self.current_tile / map.width) * map.tile_height
        self.y = self.ground - (self.height * self.scale_y)
        self.y_velocity = 0
    end
end

function player.draw(self)
    love.graphics.draw(self.images[self.current_image], self.animation_frames[math.floor(self.current_frame)], self.x, self.y, 0, self.scale_x, self.scale_y, self.offset, 0)
end