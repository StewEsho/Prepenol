--------------------------------------------------------------------------------
--
-- Controls the game logic and loop; "brains" of the game
--
-- gameloop.lua
--
------------------------------- Private Fields ---------------------------------
local ship = require ("ship")
local joystick = require ("joystick")

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

------------------------------ Public Functions --------------------------------

--constructor
function gameloop.new()
  local newGameloop = {
    gameState = 0;
    player = nil;
    stick = nil;
  }

  return setmetatable(newGameloop, gameloop_mt);
end

--Runs once to initialize the game
--Runs again everytime the game state changes
function gameloop:init()
  gameState = 2
  player = ship.new(display.contentWidth / 2, 5 * display.contentHeight / 6);
  stick = joystick.new(1.125 * display.contentWidth/8, 6 * display.contentHeight / 8);
end

--Runs continously. Different code for each different game state
function gameloop:run()
  joystick:run();
end

return gameloop;
