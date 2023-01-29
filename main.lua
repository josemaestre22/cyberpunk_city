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
    enemy:load()
    
    background = love.graphics.newImage("cyberpunk-street.png")

    -- Camera x-axis position
    cam_x = 0
    
end

function love.update(dt)
    enemy:update(dt)
    player:update(dt)

    --Camera implementation
    -- If the x-axis position of the player is more than the middle of the screen
    if player.x > love.graphics.getWidth() / 2 then
        --Move the camera
    
        --Prevent the camera from going off the right border by checking
        --If the x-axis position of the player is more than the width of the map in pixels minus the right-most half of the map visible to the player
        if player.x > (map.width * map.tile_width) - (love.graphics.getWidth() / 2) then
            cam_x = - (map.width * map.tile_width / 2)

        -- Else, the camera is not at the rightmost part of the map
        else  
            -- Move the camera x-axis by assigning it the the negative of the current player x-axis position 
            -- so that it moves to the side oposite to the player and add to it the half of the screen width so the player is at the center
            cam_x = math.floor(-player.x + love.graphics.getWidth() / 2)
        end
    end

    --Collision detection
    --Limit player to map borders
    if player.x < 0 then 
        player.x = 0
    elseif player.x + player.width > (map.width * map.tile_width) then
        player.x = (map.width * map.tile_width) - player.width
    end
end

function love.draw()
    love.graphics.translate(cam_x, 0)
    love.graphics.draw(background, 0, 0, 0, (map.width * map.tile_width) / background:getWidth(), ((map.height - 4 + 2) * map.tile_height) / background:getHeight())
    map:draw_map()
    enemy:draw()
    player:draw()
end