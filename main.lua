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
    -- Jump implementation
    if love.keyboard.isDown("up") then
        -- If the player is in the ground
        if player.y == player.ground then
            -- Change its y velocity to initiate the jump
            player.y_velocity = -400
        end
    end 
    
    -- If the player hasn't jumped
    if player.y_velocity ~= 0 then 
        player:jump_animation(dt)
        -- Initiate Jump
        player.y = player.y + player.y_velocity * dt

        -- Apply gravity
        player.y_velocity = player.y_velocity + player.gravity   
    end
    
    -- Check if the player hit the ground again
    if player.y >= player.ground then 
        player.y = player.ground
        player.y_velocity = 0
    end

    --Player horizontal movement implementation
    if love.keyboard.isDown("right") then
        if player.ground == player.y then
            player:run_animation(dt)
        end
        player.scale_x = 2
        player.offset = 0
        player.x = player.x + player.speed * dt

    elseif love.keyboard.isDown("left") then
        if player.ground == player.y then
            player:run_animation(dt)
        end
        player.scale_x = -2
        player.offset = player.width / 2
        player.x = player.x - player.speed * dt

    else
        if player.ground == player.y then
            player:idle_animation(dt)
        end
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

    --Collision detection
    --Limit player to map borders
    if player.x < 0 then 
        player.x = 0
    elseif player.x + player.width > (map.width * map.tile_width) then
        player.x = (map.width * map.tile_width) - player.width
    end

    -- Make player fall
    print("player X: " .. player.x)
    print("player Y: " .. player.y)
end

function love.draw()
    love.graphics.translate(cam_x, 0)
    love.graphics.draw(background, 0, 0, 0, (map.width * map.tile_width) / background:getWidth(), ((map.height - player.tile + 2) * map.tile_height) / background:getHeight())
    map:draw_map()
    love.graphics.draw(player.images[player.current_image], player.animation_frames[math.floor(player.current_frame)], player.x, player.y, 0, player.scale_x, player.scale_y, player.offset, 0)
end