function love.load()
    -- Set filter to nearest to prevent bluriness when scaling sprites
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Tilemap
    require("map")
    map:generate_quads()

    --Player implementation
    require("player")
    player:generate_quads()

    background = love.graphics.newImage("cyberpunk-street.png")

    -- Camera x-axis position
    cam_x = 0
    
end

function love.update(dt)
    --Player movement
    if love.keyboard.isDown("right") then
        player:run_animation(dt)
        player.scale_x = 2
        player.offset = 0
        player.x = player.x + player.speed * dt

    elseif love.keyboard.isDown("left") then
        player:run_animation(dt)
        player.scale_x = -2
        player.offset = player.width / 2
        player.x = player.x - player.speed * dt

    else
        player:idle_animation(dt)
    end

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
end

function love.draw()
    love.graphics.translate(cam_x, 0)
    love.graphics.draw(background, 0, 0, 0, (map.width * map.tile_width) / background:getWidth(), ((map.height - player.tile + 2) * map.tile_height) / background:getHeight())
    map:draw_map()
    love.graphics.draw(player.images[player.current_image], player.animation_frames[math.floor(player.current_frame)], player.x, player.y, 0, player.scale_x, player.scale_y, player.offset, 0)
end