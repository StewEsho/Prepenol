--------------------------------------------------------------------------------
--
-- Controls the game logic and loop; "brains" of the game
--
-- gameloop.lua
--
------------------------------- Private Fields ---------------------------------
local ship = require ("ship")
local joystick = require ("joystick")
local button = require ("button")
local physics = require("physics")
local perspective = require("perspective")

local gameloop = {};
local gameloop_mt = {}; --metatable

--[[  Stores the gameState
  0 = not initialized
  1 = main menu
  2 = gameplay
  3 = pause menu
]]
local gameState;
local player;
local stick;
local fireBttn;
local camera;
local debaq;
------------------------------ Public Functions --------------------------------

--constructor
function gameloop.new()
  local newGameloop = {
    gameState = 0;
  }

  return setmetatable(newGameloop, gameloop_mt);
end

--Runs once to initialize the game
--Runs again everytime the game state changes
function gameloop:init()
  gameState = 2

  player = ship.new(display.contentWidth / 2, 3 * display.contentHeight / 4, 0.75);
  physics.addBody (player, "kinematic")
  stick = joystick.new(1.125 * display.contentWidth/8, 6 * display.contentHeight / 8);
  fireBttn = button.new(display.contentWidth - (display.contentHeight/4),
                        display.contentHeight-(display.contentHeight/6),
                        display.contentHeight/2, display.contentHeight/3,
                        true,
                        1,
                        0.2,
                        0.25,
                        "fire");

  player:init();
  stick:init();
  fireBttn:init();

  --Used to allow the camera to follow the player
  camera = perspective.createView();
  camera:add(player:getDisplayObject(), 1) -- Add player to layer 1 of the camera
  camera:prependLayer();

  --------------------------------------------------------------------------------
-- "Scenery"
--------------------------------------------------------------------------------
  local scene = {}
  for i = 1, 100 do
  	scene[i] = display.newCircle(0, 0, 10)
  	scene[i].x = math.random(display.screenOriginX, display.contentWidth * 3)
  	scene[i].y = math.random(display.screenOriginY, display.contentHeight)
  	scene[i]:setFillColor(math.random(100) * 0.01, math.random(100) * 0.01, math.random(100) * 0.01)
  	camera:add(scene[i], math.random(0, camera:layerCount()))
  end

  camera:setParallax(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3) -- Here we set parallax for each layer in descending order

  camera.damping = 4; -- A bit more fluid tracking
  camera:setFocus(player:getDisplayObject()); -- Set the focus to the player
  camera:track(); -- Begin auto-tracking
end

--Runs continously. Different code for each different game state
function gameloop:run(event)
  stick:debug();
  player:run();

  if (fireBttn:isPressed() == true) then
    player:setIsShooting(true);
  else
    player:setIsShooting(false);
  end
end

return gameloop;
