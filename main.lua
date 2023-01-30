function love.load()
    -- Set filter to nearest to prevent bluriness when scaling sprites
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    -- Tilemap
    require("map")
    map:load()

    --Player implementation
    require("player")
    player:load()

    -- Enemies implementation
    require("enemies")
    enemies = {}
    for i=1, 4 do
        enemies[i] = enemy:new(i * 100)
    end
end

function love.update(dt)
    player:update(dt)
    for i=1, #enemies do
        enemies[i]:update(dt)
    end
end

function love.draw()
    love.graphics.translate(player.cam_x, 0) --Move the camera
    map:draw()
    player:draw()
    for i=1, #enemies do
        enemies[i]:draw()
    end
end