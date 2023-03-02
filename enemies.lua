-- Enemies list
enemies = {}

-- Enemy Class
enemy = {
    images = {love.graphics.newImage("assets/sprite_sheets/enemy_1/Idle.png"), love.graphics.newImage("assets/sprite_sheets/enemy_1/Walk.png"), love.graphics.newImage("assets/sprite_sheets/enemy_1/Attack.png")},
    frame_width = 48,
    frame_height = 48,
    top_blank_space = 8,
    right_blank_space = 27,
    offset = 0,
    speed = 150,
    gravity = 15,
    vy = gravity,
    animations = {},
    current_animation = 1
}

-- Enemy Constructor
function enemy:new(enemy_number)
    object = {}   -- create object
    setmetatable(object, self)
    self.__index = self
    object.x = map.layers["Spawn Points"].objects[enemy_number].x
    object.y = map.layers["Spawn Points"].objects[enemy_number].y
    object.width = map.layers["Spawn Points"].objects[enemy_number].width
    object.height = map.layers["Spawn Points"].objects[enemy_number].height
    object.scale_x = object.width / (self.frame_width - self.right_blank_space)
    object.scale_y = object.height / (self.frame_height - self.top_blank_space)
    for i, image in ipairs(self.images) do
        self.animations[i] = anim8.newAnimation((anim8.newGrid(self.frame_width, self.frame_height, image:getWidth(), image:getHeight())("1-" .. self.images[i]:getWidth() / self.frame_width, 1)), 0.12)
    end
    return object
end

function enemies:load()
    for i=2, #map.layers["Spawn Points"].objects do
        enemies[i - 1] = enemy:new(i)
    end
end

function enemies:update(dt)
    for i, enemy in ipairs(enemies) do
        enemy.animations[enemy.current_animation]:update(dt)
    end
end

function enemies:draw()
    for i, enemy in ipairs(enemies) do
        enemy.animations[enemy.current_animation]:draw(enemy.images[enemy.current_animation], enemy.x, enemy.y, 0, self.scale_x, self.scale_y, enemy.offset)
    end
end