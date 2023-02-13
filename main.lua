-- Include Simple Tiled Implementation into project
local sti = require "libraries/Simple-Tiled-Implementation/sti"

function love.load()
    map = sti("tiled_map/Sidescroller city map extended.lua")
end

function love.update(dt)
    map:update(dt)
end

function love.draw()
    map:draw()
end