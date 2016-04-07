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
local debaq
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
  system.activate( "multitouch" )
  gameState = 2

  debaq = display.newText("123", 333, 444, "Arial", 60)
  player = ship.new(display.contentWidth / 2, 3 * display.contentHeight / 4, 0.5);
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
end

--Runs continously. Different code for each different game state
function gameloop:run(event)
  stick:debug();
  player:run();

  if (fireBttn:isPressed() == true) then
    player:setIsShooting(true);
    debaq.text = isShooting;
  else
    player:setIsShooting(false);
    debaq.text = isShooting;
  end
end

return gameloop;
