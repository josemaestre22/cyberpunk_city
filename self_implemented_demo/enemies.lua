-- Enemies list
enemies = {}

-- Enemy Class
enemy = {
    images = {love.graphics.newImage("assets/sprite_sheets/enemy_1/Idle.png"), love.graphics.newImage("assets/sprite_sheets/enemy_1/Walk.png"), love.graphics.newImage("assets/sprite_sheets/enemy_1/Attack.png")},
    width = 48,
    height = 48,
    scale_x = 2,
    scale_y = 2,
    offset = 0,
    speed = 150,
    animation_frames = {},
    current_image = 1,
    current_frame = 1,
    directions = {"left", "right"},
    collided = false,
    target_distance = 224,
    time = 0
}

-- Enemy Constructor
function enemy:new(enemy_number, enemies_amount)
    object = {}   -- create object
    setmetatable(object, self)
    self.__index = self
    local distance_between_enemies = ((map.width * map.tile_width) - 250 )/ enemies_amount
    object.x = distance_between_enemies * enemy_number
    object.y = (map.height * map.tile_height) - (object.height * object.scale_y) - (map.tile_height * 4)
    object.current_tile = math.floor((object.y + object.height  * object.scale_y) / map.tile_height) * map.width + math.floor((object.x / map.tile_width + 1))
    --If the enemy spawned on top of an empty tile lower it two tile rows
    if map.tile_map[object.current_tile] == 0 then
        object.current_tile = object.current_tile + (map.width * 2)
        object.y = (math.floor(object.current_tile / map.width) * map.tile_height) - (object.height * object.scale_y)
    end
    object.walk_distances = {object.x - distance_between_enemies + self.width, object.x + distance_between_enemies - self.width}
    object.last_x = object.x
    math.randomseed(os.time() / enemy_number)
    object.direction = self.directions[math.floor(math.random(2))]
    object:generate_quads()
    return object
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

function enemy.attack_animation(self, dt)
    self.current_image = 3
    if self.current_frame >= 11 and self.current_frame <= 13 then
        self.current_frame = self.current_frame + 1.5 * dt
    else
        self.current_frame = 11
    end
end

-- Check enemy collision with player
function enemy.check_collision(self, entity)
    local entity_left = entity.x
    local entity_right = entity.x + entity.width
    local entity_top = entity.y
    local entity_bottom = entity.y + entity.height
    
    local enemy_left = self.x
    local enemy_right = self.x + self.width
    local enemy_top = self.y 
    local enemy_bottom = self.y + self.height
    
    --If entity's right side is further to the right than the enemy's left side.
    if  entity_right > enemy_left
    --and entity's left side is further to the left than the enemy's right side.
    and entity_left < enemy_right
    --and entity's bottom side is further to the bottom than the enemy's top side.
    and entity_bottom > enemy_top
    --and entity's top side is further to the top than the enemy's bottom side then..
    and entity_top < enemy_bottom then
        --There is collision!
        return true
    else
        --If one of these statements is false, return false.
        return false
    end
end

function enemy.resolve_collision(self, entity, dt)
    -- How much the enemy needs to push the player so they aren't touching anymore
    local push_distance = 0
    
    -- Player right side collision with enemy left side
    if entity.last_x <  self.x then
        push_distance = (entity.x + entity.width) - self.x
        entity.x = entity.x - push_distance
        
        if entity.x  < 1 then 
            self.direction = "right"
        end
        
        -- Player left side collision with right left side
    elseif entity.last_x > self.x then
        push_distance = entity.x - (self.x  + self.width)
        entity.x = entity.x - push_distance
    end
    
    if entity == player then
        if self.collided == false then
            entity.lives = entity.lives - 1
            self.collided = true
        end
    else
        if self.direction == "left" then
            self.direction = "right"
        else
            self.direction = "left"
        end
    end
end

function enemies.load(self, enemies_amount)
    for i=1, enemies_amount do
        enemies[i] = enemy:new(i, enemies_amount)
    end
end

function enemy.update(self, dt)
    self.last_x = self.x
    self.time = self.time + dt

    if self.direction == "left" and self.x > self.walk_distances[1] and  self.x > 0 then
        self.scale_x = -2
        self.offset = self.width / 2
        
        if player.x >= self.x - self.target_distance and player.x <= self.x and player.y == self.y then
            self:attack_animation(dt)
            if self.time >= 1 then
                table.insert(bullets, bullet:new(self))
                self.time = 0
            end
        else
            self:walk_animation(dt)
            self.x = self.x - self.speed * dt   
        end
        
    else 
        self.direction = "right"
    end
    
    if self.direction == "right" and self.x < self.walk_distances[2] and self.x < map.width * map.tile_width then
        self.scale_x = 2
        self.offset = 0

        if player.x <= self.x + self.target_distance and player.x >= self.x and player.y == self.y then
            self:attack_animation(dt)
            if self.time >= 1 then
                table.insert(bullets, bullet:new(self))
                self.time = 0
            end
        else
            self:walk_animation(dt)
            self.x = self.x + self.speed * dt   
        end
        
    else
        self.direction = "left"
    end
    
    self.current_tile = math.floor((self.y + self.height  * self.scale_y) / map.tile_height) * map.width + math.floor((self.x / map.tile_width + 1))
    
    -- Ramp collision detection
    if map.tile_map[self.current_tile + 1] == 0 then
        self.y = self.y + map.tile_height
    elseif map.tile_map[self.current_tile - map.width + 1] ~= 0 then
        self.y = self.y - map.tile_height
    end
    
    if self:check_collision(player) then
        self:resolve_collision(player, dt)
    else
        self.collided = false
    end
    
    for i, enemy in ipairs(enemies) do
        if self:check_collision(enemy) and enemy.x ~= self.x then
            self:resolve_collision(enemy, dt)
        end
    end
end

function enemy.draw(self)
    love.graphics.draw(self.images[self.current_image], self.animation_frames[math.floor(self.current_frame)], self.x, self.y, 0, self.scale_x, self.scale_y, self.offset, 0)
end