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
local powerup = require("powerup_manager");
local gui = require("gui");

local gameloop = {};
local gameloop_mt = {}; --metatable

--[[  Stores the gameState
  0 = not initialized
  1 = main menu
  2 = gameplay
  3 = pause menu
  4 = game over
]]
local gameState = 0;
local player;
local testEn;
local enemy;
local powerups;
local hud;
------------------------------ Public Functions --------------------------------

--Runs once to initialize the game
--Runs again everytime the game state changes
function gameloop:init()
  --initializes system variables and settings
  math.randomseed(os.time()); math.random(); math.random();
  display.setDefault("background", 30/255, 15/255, 27/255);
  system.activate("multitouch");
  native.setProperty("androidSystemUiVisibility", "immersiveSticky");
  display.setStatusBar(display.HiddenStatusBar);
  --physics.setDrawMode("hybrid");

  --sets gamestate
  gameState = 2;

  --creates instances of classes
  enemy = enemies.new();
  player = ship.new(0, 0, 0.75);
  powerups = powerup.class();

  --initializes instances
  scene:init(1);
  player:init();

  powerups:spawn(1, {x = 300, y = 300})

  --initializes the hud
  hud = gui.class({player = player:getDisplayObject()});
end

--Runs continously. Different code for each different game state
function gameloop:run()
  if(false) then
    gameState = 4;
  end

  if(gameState == 2) then
    player:debug();

    enemy:randomSpawn(player:getX(), player:getY(), {radar = hud:get(4, 1)}) --spawns enemies randomly
    powerups:randomSpawn(player:getX(), player:getY()) --spawns powerups randomly
    player:run(hud:get(3, 1), hud:get(4, 1)); --runs player controls
    enemy:run({}); --runs enemy logic
    powerups:run(); --runs misc. powerup animations and event listeners
    hud:run(); --runs HUD and GUI elements
  elseif(gameState == 4) then
    --if player.getGameOverBG().alpha <= 0.9 then
    --  player.getGameOverBG().alpha = player.getGameOverBG().alpha + 0.01
    --else
    --  gameOverText.text = "gaem is ded"
    --end
  end
end

return gameloop;
