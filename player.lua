--Player sprite and its animations
player = {}
player.images = {love.graphics.newImage("/sprite_sheets/Biker_idle.png"), love.graphics.newImage("sprite_sheets/Biker_run.png")}

-- Dimensions of each indiviual character movement image in the sprite sheet
player.width = 48
player.height = 48

-- Each of the animation frames in the sprite_sheet
player.animation_frames = {}

-- Player scale  and offset variables used to make the character bigger and to flip it using negative x scale values and changing offset to half its width
player.scale_x = 2
player.scale_y = 2
player.offset = 0

-- Variables to determine the current image and frame of that image in each animation
player.current_frame = 1
player.current_image = 1

-- Player positional variables  
player.tile = 4 -- The tile where the player is currently at counting from the bottom up
player.x = 0
player.y = (map.height * map.tile_height) - (player.height * player.scale_y) - (map.tile_height * player.tile) --map height in pixels, player height in pixels, player position in pixels.
player.speed = 200


-- Generate quads of all of the animation frames in the sprite_sheets
function player.generate_quads(self)
    for i, image in ipairs(self.images) do
        for j = 0, image:getWidth() / self.width - 1 do
            table.insert(self.animation_frames, love.graphics.newQuad(j * self.width, 0, self.width, self.height, image:getWidth(), image:getHeight()))
        end
    end
end

function player.idle_animation(self, dt)
    self.current_image = 1
    if self.current_frame <= 4 then
        self.current_frame = self.current_frame + 5 * dt
    else
        self.current_frame = 1
    end
end

function player.run_animation(self, dt)
    self.current_image = 2
    if self.current_frame >= 5 and self.current_frame <= 10 then
        self.current_frame = self.current_frame + 10 * dt
    else
        self.current_frame = 5
    end
end