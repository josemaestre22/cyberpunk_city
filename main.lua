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
    
end

function love.update(dt)
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
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, (map.width * map.tile_width) / background:getWidth(), ((map.height - player.tile + 2) * map.tile_height) / background:getHeight())
    map:draw_map()
    love.graphics.draw(player.images[player.current_image], player.animation_frames[math.floor(player.current_frame)], player.x, player.y, 0, player.scale_x, player.scale_y, player.offset, 0)
end