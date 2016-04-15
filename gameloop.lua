--------------------------------------------------------------------------------
--
-- Controls the game logic and loop; "brains" of the game
--
-- gameloop.lua
--
------------------------------- Private Fields ---------------------------------
local ship = require ("ship");
local joystick = require ("joystick");
local button = require ("button");
local physics = require("physics");
local scene = require("scene");
local enemy = require("enemy");
local skeleton = require("en_skeleton");

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
local testScene;
local testEn;
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
  math.randomseed(os.time());
  display.setDefault( "background", 30/255, 15/255, 27/255);
  system.activate( "multitouch" );
  gameState = 2

  testScene = scene.new();
  player = ship.new(0, 0, 0.75);
  testEn = skeleton.new(100, 800, 300, 300, 10, 10);

  stick = joystick.new(1.125 * display.contentWidth/8, 6 * display.contentHeight / 8);
  fireBttn = button.new(display.contentWidth - (display.contentHeight/4),
                        display.contentHeight-(display.contentHeight/6),
                        display.contentHeight/2, display.contentHeight/3,
                        true,
                        1,
                        0.2,
                        0.25,
                        0.25,
                        "fire");
  player:init();
  testEn:init("img/sprites/skel.jpg")
  stick:init();
  fireBttn:init();

  testScene:init(1);
  testScene:addObjectToScene(player:getDisplayObject(), 1);
  testScene:addObjectToScene(testEn:getDisplayObject(), 1);
  testScene:addFocusTrack(player:getDisplayObject());
end

--Runs continously. Different code for each different game state
function gameloop:run(event)
  player:run();
  --player:debug();

  if (fireBttn:isPressed() == true) then
    player:setIsShooting(true);
  else
    player:setIsShooting(false);
  end
end

return gameloop;
