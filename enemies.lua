enemy = {}

function enemy.load(self)
    self.images = {love.graphics.newImage("sprite_sheets/enemy_1/Idle.png"), love.graphics.newImage("sprite_sheets/enemy_1/Walk.png")}
    
    self.width = 48
    self.height = 48
    
    self.scale_x = 2
    self.scale_y = 2
    self.offset = 0
    
    math.randomseed(os.time())
    self.x = math.random(player.x + 200, (map.width * map.tile_width) - (self.width * self.scale_x))
    
    self.y = (map.height * map.tile_height) - (self.height * self.scale_y) - (map.tile_height * 4)
    self.current_tile = math.floor((self.y + self.height  * self.scale_y) / map.tile_height) * map.width + math.floor((self.x / map.tile_width + 1))

    --If the enemy spawned on top of an empty tile lower it two tile rows
    if map.tile_map[enemy.current_tile] == 0 then
        enemy.current_tile = enemy.current_tile + (map.width * 2)
        enemy.y = (math.floor(enemy.current_tile / map.width) * map.tile_height) - (enemy.height * enemy.scale_y)
    end

    self.speed = 200
    
    self.animation_frames = {}
    
    self.current_image = 1
    self.current_frame = 1
    
    self.direction = "right"
    
    self:generate_quads()  
end


-- Generate quads of all of the animation frames in the sprite_sheets
function enemy.generate_quads(self)
    for i, image in ipairs(self.images) do
        for j = 0, image:getWidth() / self.width - 1 do
            table.insert(self.animation_frames, love.graphics.newQuad(j * self.width, 0, self.width, self.height, image:getWidth(), image:getHeight()))
        end
    end
end

function enemy.idle_animation(self, dt)
    self.current_image = 1
    if self.current_frame <= 4 then
        self.current_frame = self.current_frame + 5 * dt
    else
        self.current_frame = 1
    end
end

function enemy.walk_animation(self, dt)
    self.current_image = 2
    if self.current_frame >= 5 and self.current_frame <= 10 then
        self.current_frame = self.current_frame + 10 * dt
    else
        self.current_frame = 5
    end
end

function enemy.update(self, dt)
    if self.direction == "right" and enemy.x < map.width * map.tile_width then
        self.scale_x = 2
        self.offset = 0
        self:walk_animation(dt)
        self.x = self.x + self.speed * dt
        
        -- Ramps Collision detection (COULD IMPROVE BY CHECKING FOR X-AXIS COLLISION)
        if map.tile_map[self.current_tile] == 43 or map.tile_map[self.current_tile] == 44 then
            self.y = self.y + map.tile_height
        end
        if map.tile_map[self.current_tile - map.width] == 45 or map.tile_map[self.current_tile - map.width] == 46 then
            self.y = self.y - map.tile_height
        end
        
    else
        self.direction = "left"
    end
    
    if self.direction == "left" and enemy.x > 0 then
        self.scale_x = -2
        self.offset = self.width / 2
        self:walk_animation(dt)
        self.x = self.x - self.speed * dt
        
        -- Ramps Collision detection (COULD IMPROVE BY CHECKING FOR X-AXIS)
        if map.tile_map[self.current_tile - map.width] == 43 or map.tile_map[self.current_tile - map.width] == 4 then
            self.y = self.y - map.tile_height
        end
        if map.tile_map[self.current_tile] == 45 or map.tile_map[self.current_tile] == 46 then
            self.y = self.y + map.tile_height
        end
        
    else
        self.direction = "right"
    end
    
    self.current_tile = math.floor((self.y + self.height  * self.scale_y) / map.tile_height) * map.width + math.floor((self.x / map.tile_width + 1))
    
end

function enemy.draw(self)
    love.graphics.draw(self.images[self.current_image], self.animation_frames[math.floor(self.current_frame)], self.x, self.y, 0, self.scale_x, self.scale_y, self.offset, 0)
end