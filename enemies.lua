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
    speed = 200,
    animation_frames = {},
    current_image = 1,
    current_frame = 1,
    direction = "left"
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
    object:generate_quads()
    return object
end

function enemies.load(self, x)
    for i=1, x do
        enemies[i] = enemy:new(i * 2 ^ i)
    end
end

function enemy.update(self, dt)
    if self.direction == "right" and self.x < map.width * map.tile_width then
        self.scale_x = 2
        self.offset = 0
        self:walk_animation(dt)
        self.x = self.x + self.speed * dt
        
    else
        self.direction = "left"
    end
    
    if self.direction == "left" and self.x > 0 then
        self.scale_x = -2
        self.offset = self.width / 2
        self:walk_animation(dt)
        self.x = self.x - self.speed * dt

    else
        self.direction = "right"
    end
    
    self.current_tile = math.floor((self.y + self.height  * self.scale_y) / map.tile_height) * map.width + math.floor((self.x / map.tile_width + 1))

    -- Ramp collision detection
    if map.tile_map[self.current_tile + 1] == 0 then
        self.y = self.y + map.tile_height
    elseif map.tile_map[self.current_tile - map.width + 1] ~= 0 then
        self.y = self.y - map.tile_height
    end

    if self:check_collision() then
        player:hurt_animation(dt)
        if player.direction == "right" then
            player.x = player.x - player.speed * dt
        elseif player.direction == "left" then
            player.x = player.x + player.speed * dt
        end
    end
end

function enemy.draw(self)
    love.graphics.draw(self.images[self.current_image], self.animation_frames[math.floor(self.current_frame)], self.x, self.y, 0, self.scale_x, self.scale_y, self.offset, 0)
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

    --If Red's right side is further to the right than Blue's left side.
    if  player_right > enemy_left
    --and Red's left side is further to the left than Blue's right side.
    and player_left < enemy_right
    --and Red's bottom side is further to the bottom than Blue's top side.
    and player_bottom > enemy_top
    --and Red's top side is further to the top than Blue's bottom side then..
    and player_top < enemy_bottom then
        --There is collision!
        return true
    else
        --If one of these statements is false, return false.
        return false
    end
end