-- Enemies list
enemies = {}

-- Enemy Class
enemy = {
    frame_width = 48,
    frame_height = 48,
    top_blank_space = 8,
    right_blank_space = 24,
    offset = 0,
    gravity = 15,
}

-- Enemy Constructor
function enemy:new(enemy_number)
    object = {}   -- create object
    setmetatable(object, self)
    self.__index = self
    object.images = {love.graphics.newImage("assets/sprite_sheets/enemy_1/Idle.png"), love.graphics.newImage("assets/sprite_sheets/enemy_1/Walk.png"), love.graphics.newImage("assets/sprite_sheets/enemy_1/Attack.png")}
    object.x = map.layers["Spawn Points"].objects[enemy_number].x
    object.y = map.layers["Spawn Points"].objects[enemy_number].y
    object.width = map.layers["Spawn Points"].objects[enemy_number].width
    object.height = map.layers["Spawn Points"].objects[enemy_number].height
    object.vx = 150
    object.vy = self.gravity
    object.scale_x = object.width / (self.frame_width - self.right_blank_space)
    object.scale_y = object.height / (self.frame_height - self.top_blank_space)
    object.animations = {}
    object.current_animation = 1

    for i, image in ipairs(object.images) do
        object.animations[i] = anim8.newAnimation((anim8.newGrid(self.frame_width, self.frame_height - self.top_blank_space, image:getWidth(), image:getHeight(), 0, self.top_blank_space)("1-" .. object.images[i]:getWidth() / self.frame_width, 1)), 0.12)
    end

    world:add(object, object.x, object.y, object.width, object.height)

    return object
end

function enemies:load()
    for i=2, #map.layers["Spawn Points"].objects do
        enemies[i - 1] = enemy:new(i)
    end
end

function enemies:update(dt)
    for i, enemy in ipairs(self) do
        enemy:move(dt)
        enemy.animations[enemy.current_animation]:update(dt)
    end
end

function enemies:draw()
    for i, enemy in ipairs(self) do
        enemy.animations[enemy.current_animation]:draw(enemy.images[enemy.current_animation], enemy.x, enemy.y, 0, enemy.scale_x, enemy.scale_y, enemy.offset)
    end
end

function enemy:move(dt)
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:check(self, goalX, goalY)
    print(len)
    world:update(self, actualX, actualY) -- update the self's rectangle in the world
    self.x, self.y = actualX, actualY
  end