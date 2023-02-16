-- Simple Tiled Implementation library for implementing the tiled made tile map
local sti = require "libraries/Simple-Tiled-Implementation/sti"

-- Anim8 library for animations
local anim8 = require "libraries/anim8/anim8"

-- Bump library for physics and collision detection
local bump = require "libraries/bump/bump"

function love.load()
	-- Load map file
	map = sti("tiled_map/Sidescroller city map extended.lua")
	for k, object in pairs(map.objects) do
		if object.name == "Player" then
			print(object)
			break
		end
	end
end

function love.update(dt)
	-- Update world
	map:update(dt)
end

function love.draw()
	-- Draw world
	map:draw()
end