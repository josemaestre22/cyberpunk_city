function love.load()
    love.window.setTitle("Cyberpunk City")
    -- Player table (similar to a python dict or a Javascript object)
    player = {}
    -- Sprite dimensions
    player.width = 50
    player.height = 75
    -- Sprite starting position
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() - player.height
    -- Sprite movement variables
    player.speed = 200
    player.jump_starting_position = player.y
    player.jump_height = player.jump_starting_position -200
    player.
    

end

function love.draw()
    -- Draw sprite
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
end

function love.update(dt)
    -- Character movement
    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt -- dt used to make game or movement speed the same independent of system speed
    elseif love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown("up") then
        print(player.y)
    end
    -- Collition detection for the left and right window borders 
    if player.x < 0 then
        player.x = 0
    elseif player.x + player.width > love.graphics.getWidth() then  -- player.x + player.width used to calculate the location of the rightmost side of the player
        player.x = love.graphics.getWidth() - player.width
    end
end