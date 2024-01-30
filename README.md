# CYBERPUNK CITY
## Description
Cyberpunk city is a simple 2D sidescroller platformer video game with cyberpunk, retro and synthwave aesthetics made using the love2d game development framework and the lua programming language.
## Game dynamic
In order to beat the game you need to escape from the city!

To escape from the city you need to reach the space ship that's located at the end of the map.

To do this you have to make your way across the map, while avoiding the patrolling enemies in each platform and dodging their bullets which they'll shoot if they ever spot you near to them.
You have three lives which are lost each time you take damage from an enemy and if you lose them all you will die and need to start from the beginning, so be extremely careful to not loose your lives!

## Design
The video game's code is divided across multiple files, each of which contains the code of each of the entities that are present in the video game such as the player, enemies, bullets, space ship, and map.
This is done to give the code of the video game modularity and as a consequence allowing it to be more comprehensible and easier to work with, instead of writing all of it in the same main.lua file.

The functions of each entity are structured following the same pattern as the love2d framework function calls, for example, enemy:load(), player:update and map:draw(), so that the lines of code of each entity are grouped according to their functionality and in which function of the code of the main.lua file they are going to be called, by providing each entity with the same foundational functions such as load(), update() and draw() all of the entity files follow the same pattern, making the development of the video game and the comprehension of the code a lot easier.

There's also a self implemented folder where I made a a basic demo of the game, in which all of the components of the game such as animations, collition detection, tile map rendering and camera were implemented by myself as a way to better learn how all of these components may be implemented in a 2D video game from scratch.

## Credits
For the final version of this project I've used some popular lua libraries for game development using the love2d framework in order to implement some of the componets of the video game, them being the Simpled Tiled implementation, Bump.lua and gamera libraries for the implementations of tile map rendering, box collision detection, and camera respectively.

I also used the Tiled open source level editor to make the tile map for the video game.
