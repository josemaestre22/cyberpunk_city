-- Simple Tiled Implementation library for implementing the tiled made tile map
local sti = require "libraries/Simple-Tiled-Implementation/sti"

-- Anim8 library for animations
anim8 = require "libraries/anim8/anim8"

-- Bump library for physics and collision detection
local bump = require "libraries/bump/bump"

require"player"

function love.load()
	love.graphics.setDefaultFilter( "nearest" )
	-- Load map file and collidable world
	map = sti("tiled_map/Sidescroller city map extended.lua", {"bump"})
	world = bump.newWorld()
	map:bump_init(world)

	-- Load player
	player:load()
end

function love.update(dt)
	-- Update world
	map:update(dt)
	player:update(dt)
end

function love.draw()
	-- Draw world
	map:draw()
	map:bump_draw()
	player:draw()
end