--------------------------------------------------------------------------------
--
-- Controls the game logic and loop; "brains" of the game
--
-- gameloop.lua
--
------------------------------- Private Fields ---------------------------------
local ship = require ("ship");
local physics = require("physics");
local scene = require("scene");
local enemies = require("enemies");

local gameloop = {};
local gameloop_mt = {}; --metatable

--[[  Stores the gameState
  0 = not initialized
  1 = main menu
  2 = gameplay
  3 = pause menu
]]
local gameState = 0;
local player;
local stick;
local fireBttn;
local testEn;
local enemy;
local debugText = display.newText( "", display.contentWidth/2, display.contentHeight/4, native.systemFontBold, 120 ) --general purpose debugging text
------------------------------ Public Functions --------------------------------

--Runs once to initialize the game
--Runs again everytime the game state changes
function gameloop:init()
  --initializes system variables and settings
  math.randomseed(os.time()); math.random(); math.random();
  display.setDefault("background", 30/255, 15/255, 27/255);
  system.activate("multitouch");
  native.setProperty("androidSystemUiVisibility", "immersiveSticky");
  --physics.setDrawMode("hybrid");

  --sets gamestate
  gameState = 2;

  --creates instances of classes
  enemy = enemies.new();
  player = ship.new(0, 0, 0.75);
  --initializes instances
  scene:init(1);
  player:init();
  player:initHUD();
end

--Runs continously. Different code for each different game state
function gameloop:run()

  player:run(); --runs player controls
  --player:debug();

  enemy:randomSpawn(player:getX(), player:getY()) --spawns enemies randomly
  enemy:run(); --runs enemy logic
end

return gameloop;
