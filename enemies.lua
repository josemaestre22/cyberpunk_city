-- Enemies list
enemies = {}

-- Enemy Class
enemy = {
    images = {love.graphics.newImage("assets/sprite_sheets/enemy_1/Idle.png"), love.graphics.newImage("assets/sprite_sheets/enemy_1/Walk.png"), love.graphics.newImage("assets/sprite_sheets/enemy_1/Attack.png")},
    frame_width = 48,
    frame_height = 48,
    width = map.layers["Spawn Points"].objects[2].x
    height = map.layers["Spawn Points"].objects[2].x
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
function enemy:new(enemy_number)
    object = {}   -- create object
    setmetatable(object, self)
    self.__index = self
    object.x = map.layers["Spawn Points"].objects[i].x
    object.y = map.layers["Spawn Points"].objects[i].y

    return object
end

function enemies.load(self)
    for i=2, #map.layers["Spawn Points"].objects - 1  do
        enemies[i] = enemy:new(i)
    end
end

function enemy.update(self, dt)
    
end

function enemy.draw(self)
    love.graphics.draw(self.images[self.current_image], self.animation_frames[math.floor(self.current_frame)], self.x, self.y, 0, self.scale_x, self.scale_y, self.offset, 0)
end