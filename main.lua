-- Include Simple Tiled Implementation into project
local sti = require "libraries/Simple-Tiled-Implementation/sti"
local bump = require"libraries/bump"

function love.load()
    map = sti("tiled_map/Sidescroller city map extended.lua")
    world = bump.newWorld()
end

function love.update(dt)
    map:update(dt)
end

function love.draw()
    map:draw()
end