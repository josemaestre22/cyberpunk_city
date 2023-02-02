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
    enemies:load(3)
end

function love.update(dt)
    player:update(dt)
    for i=1, #enemies do
        enemies[i]:update(dt)
    end
end

function love.draw()
    love.graphics.push() -- Used to be able to correctly dipsplay lives HUD without it being translated by the camera
    love.graphics.translate(player.cam_x, 0) --Move the camera
    map:draw()
    player:draw()
    for i=1, #enemies do
        enemies[i]:draw()
    end
    love.graphics.pop() -- Used to be able to correctly dipsplay lives HUD without it being translated by the camera
    for i=0, player.lives - 1 do
        love.graphics.draw(player.lives_image, (i * player.lives_image:getWidth() * 2.25 ), 0, 0, 4 , 4)
    end
end