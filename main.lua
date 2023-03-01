-- Simple Tiled Implementation library for implementing the tiled made tile map
local sti = require "libraries/Simple-Tiled-Implementation/sti"

-- Anim8 library for animations
anim8 = require "libraries/anim8/anim8"

-- Bump library for physics and collision detection
local bump = require "libraries/bump/bump"

-- Camera module from the hump library for camera implementation
local Camera = require "libraries/hump/camera"

require"player"
require"enemies"

function love.load()
	love.graphics.setDefaultFilter( "nearest" )
	-- Load map file and collidable world
	map = sti("tiled_map/Sidescroller city map extended.lua", {"bump"})
	world = bump.newWorld()
	map:bump_init(world)

	-- Load player
	player:load()

	-- Load enemies	
	-- enemies:load()
	camera = Camera(player.x, player.y)
end

function love.update(dt)
	-- Update world
	map:update(dt)
	player:update(dt)
	-- enemies:update(dt)
	camera:lookAt(player.x, player.y)
end

function love.draw()
	camera:attach()
		-- Draw world
		map:drawLayer(map.layers["Tiles"])
		map:bump_draw()
		player:draw()
		-- enemies:draw()
	camera:detach()
end