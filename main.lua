-- Simple Tiled Implementation library for implementing the tiled made tile map
local sti = require "libraries/Simple-Tiled-Implementation/sti"

-- Anim8 library for animations
anim8 = require "libraries/anim8/anim8"

-- Bump library for physics and collision detection
local bump = require "libraries/bump/bump"

-- Camera module from the hump library for camera implementation
local gamera = require "libraries/gamera/gamera"

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
	enemies:load()
	camera = gamera.new(0, 0, map.width * map.tilewidth, map.height * map.tileheight)
end

function love.update(dt)
	-- Update world
	map:update(dt)
	player:update(dt)
	enemies:update(dt)
	camera:setPosition(math.floor(player.x), math.floor(player.y))
end

function love.draw()
	-- Draw everything inside the camera
	camera:draw(draw_calls)
end

function draw_calls()
	for i, layer in ipairs(map.layers) do
		if layer.visible then
			map:drawLayer(map.layers[""..layer.name..""])
		end
	end
	player:draw()	
	enemies:draw()
	-- map:bump_draw()
end