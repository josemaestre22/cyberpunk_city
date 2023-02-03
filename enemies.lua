-- Enemies list
enemies = {}

-- Enemy Class
enemy = {
    images = {love.graphics.newImage("sprite_sheets/enemy_1/Idle.png"), love.graphics.newImage("sprite_sheets/enemy_1/Walk.png")},
    width = 48,
    height = 48,
    scale_x = 2,
    scale_y = 2,
    offset = 0,
    speed = 150,
    animation_frames = {},
    current_image = 1,
    current_frame = 1,
    direction = "left",
    collided = false,
    bullets = {},
}

-- Enemy Constructor
function enemy:new(seed_number)
    object = {}   -- create object
    setmetatable(object, self)
    self.__index = self
    math.randomseed(os.time() * seed_number)
    object.x = math.random(player.x + 200, (map.width * map.tile_width) - (object.width * object.scale_x))
    object.y = (map.height * map.tile_height) - (object.height * object.scale_y) - (map.tile_height * 4)
    object.current_tile = math.floor((object.y + object.height  * object.scale_y) / map.tile_height) * map.width + math.floor((object.x / map.tile_width + 1))
    --If the enemy spawned on top of an empty tile lower it two tile rows
    if map.tile_map[object.current_tile] == 0 then
        object.current_tile = object.current_tile + (map.width * 2)
        object.y = (math.floor(object.current_tile / map.width) * map.tile_height) - (object.height * object.scale_y)
    end
    object.walk_distances = {object.x - 400, object.x + 400}
    object:generate_quads()
    return object
end

-- Bullet class
bullet = {
    image = love.graphics.newImage("Ball2.png"),
    speed = 700
}

-- Bullet Constructor
function bullet:new(entity)
    object = {}   -- create object
    setmetatable(object, self)
    self.__index = self
    width = self.image:getWidth()
    height = self.image:getHeight()
    object.x = entity.x
    object.y = entity.y 
    return object
end

function bullet.shoot(self, dt, direction)
    if direction == "left" then
        self.x = self.x - self.speed * dt
    else
        self.x = self.x + self.speed * dt
    end
end

function enemies.load(self, x)
    for i=1, x do
        enemies[i] = enemy:new(i)
    end
end

function enemy.update(self, dt)
    if self.direction == "left" and self.x > self.walk_distances[1] then
        self.scale_x = -2
        self.offset = self.width / 2
        self:walk_animation(dt)
        self.x = self.x - self.speed * dt
    else
        table.insert(self.bullets, bullet:new(self))
        self.direction = "right"
    end

    if self.direction == "right" and self.x < self.walk_distances[2] then
        self.scale_x = 2
        self.offset = 0
        self:walk_animation(dt)
        self.x = self.x + self.speed * dt
    else
        table.insert(self.bullets, bullet:new(self))
        self.direction = "left"
    end

    for i=1, #self.bullets do
        self.bullets[i]:shoot(dt, direction)
    end
    
    self.current_tile = math.floor((self.y + self.height  * self.scale_y) / map.tile_height) * map.width + math.floor((self.x / map.tile_width + 1))

    -- Ramp collision detection
    if map.tile_map[self.current_tile + 1] == 0 then
        self.y = self.y + map.tile_height
    elseif map.tile_map[self.current_tile - map.width + 1] ~= 0 then
        self.y = self.y - map.tile_height
    end

    if self:check_collision() then
        self:resolve_collision(dt)
    else
        self.collided = false
    end
end

function enemy.draw(self)
    love.graphics.draw(self.images[self.current_image], self.animation_frames[math.floor(self.current_frame)], self.x, self.y, 0, self.scale_x, self.scale_y, self.offset, 0)
    for i=1, #self.bullets do
        love.graphics.draw(self.bullets[i].image, self.bullets[i].x, self.bullets[i].y)
    end
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

-- Check enemy collision with player
function enemy.check_collision(self)
    local player_left = player.x
    local player_right = player.x + player.width
    local player_top = player.y
    local player_bottom = player.y + player.height

    local enemy_left = self.x
    local enemy_right = self.x + self.width
    local enemy_top = self.y
    local enemy_bottom = self.y + self.height

    --If player's right side is further to the right than the enemy's left side.
    if  player_right > enemy_left
    --and player's left side is further to the left than the enemy's right side.
    and player_left < enemy_right
    --and player's bottom side is further to the bottom than the enemy's top side.
    and player_bottom > enemy_top
    --and player's top side is further to the top than the enemy's bottom side then..
    and player_top < enemy_bottom then
        --There is collision!
        return true
    else
        --If one of these statements is false, return false.
        return false
    end
end

function enemy.resolve_collision(self, dt)
    -- How much the enemy needs to push the player so they aren't touching anymore
    local push_distance = 0
    
    -- Player right side collision with enemy left side
    if player.last_x <  self.x then
        push_distance = (player.x + player.width) - self.x
        player.x = player.x - push_distance

    -- Player left side collision with right left side
    elseif player.last_x > self.x then
        push_distance = player.x - (self.x  + self.width)
        player.x = player.x - push_distance
    end
    
    if self.collided == false then
        player.lives = player.lives - 1
        self.collided = true
    end
end