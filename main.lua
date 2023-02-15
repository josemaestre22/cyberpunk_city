-- Include Simple Tiled Implementation for tiled map
local sti = require "libraries/Simple-Tiled-Implementation/sti"

-- Include Bump library for collisions
local bump = require"libraries/bump"

-- Include Anim8 library for animations
local anim8 = require"libraries/anim8"

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