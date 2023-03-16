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
require"bullet"
require"ship"

function love.load()
	won = false
	
	-- Set scaling filter to prevent blurrines 
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- Set window Title
	love.window.setTitle("Cyberpunk City")
	
	-- Load map file and collidable world
	map = sti("tiled_map/Sidescroller city map extended.lua", {"bump"})
	world = bump.newWorld()
	map:bump_init(world)
	
	-- Load camera
	camera = gamera.new(0, 0, map.width * map.tilewidth, map.height * map.tileheight)
	
	--Load music
	music = love.audio.newSource("assets/DavidKBD - Pink Bloom Pack - 09 - Lightyear City.ogg", "stream") -- the "stream" tells LÖVE to stream the file from disk, good for longer music tracks
	music:setLooping(true)
	music:play()
	
	-- Load player
	player:load()
	
	-- Load enemies	
	enemies:load()
	
	ship:load()
end

function love.update(dt)
	if player.dead or won then
		music:stop()
		if love.keyboard.isDown("space") then
			love.load()
		end
	else
		-- Update world and entities
		map:update(dt)
		player:update(dt)
		enemies:update(dt)
		bullets:update(dt)
		camera:setPosition(math.floor(player.x), math.floor(player.y))
	end
end

function love.draw()
	if player.dead then
		love.graphics.print("You died!", love.graphics.newFont("assets/GravityBold8.ttf"), 350, 300)
		love.graphics.print("Press Space to try again", love.graphics.newFont("assets/GravityBold8.ttf"), 275, 400)
	elseif won then
		love.graphics.print("You've escaped!", love.graphics.newFont("assets/GravityBold8.ttf"), 325, 300)
		love.graphics.print("Press Space to play again", love.graphics.newFont("assets/GravityBold8.ttf"), 275, 400)
		ship:draw()
	else
		-- Draw everything inside the camera
		camera:draw(draw_calls)
		for i=0, player.lives - 1 do
			love.graphics.draw(player.lives_image, (i * player.lives_image:getWidth() * 2.25 ), 0, 0, 4 , 4)
		end
	end
end

-- Drawing function calls of entities and map layers
function draw_calls()
	-- Draw each layer of the tiled map separatedly to allow STI to work with the gamera library camera
	for i, layer in ipairs(map.layers) do
		if layer.visible then
			map:drawLayer(map.layers[""..layer.name..""])
		end
	end
	player:draw()	
	enemies:draw()
	bullets:draw()
	ship:draw()
end