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
local progressRing = require("progressRing");

local gameloop = {};

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
  --native.setProperty("androidSystemUiVisibility", "immersiveSticky");
  --display.setStatusBar(display.HiddenStatusBar);
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

  powerups:spawn(1, {x = -300, y = -300})
  powerups:spawn(1, {x =    0, y = -300})
  powerups:spawn(1, {x =  300, y = -300})
  powerups:spawn(2, {x = -300, y = -600})
  powerups:spawn(2, {x =    0, y = -600})
  powerups:spawn(2, {x =  300, y = -600})
  powerups:spawn(3, {x = -300, y = -900})
  powerups:spawn(3, {x =    0, y = -900})
  powerups:spawn(3, {x =  300, y = -900})

  local kekme = progressRing.new({ringColor = {0.2, 0.1, 0.8}, bgColor = {0,0,0, 0.01}, position = 1, ringDepth = 1, radius = 80});
  kekme.x = 1000; kekme.y = 500
  kekme:goTo(0, 10000)

  --initializes the hud
  hud = gui.class({player = player:getDisplayObject()});
  --adds misc. objects that belong in the HUD/GUI
  hud:insert(player:getHealthGroup(), 1) --player healthbar
  for i = 1, table.getn(powerups:getTimerObject()) do
    hud:insert(powerups:getTimerObject(i), 1) --all powerup timers
  end
end

--Runs continously. Different code for each different game state
function gameloop:run()
  if(player:getIsDead()) then
    gameState = 4;
  else
    gameState = 2;
  end

  if(gameState == 2) then
    --player:debug();

    enemy:randomSpawn(player:getX(), player:getY(), {radar = hud:get(4, 1)}) --spawns enemies randomly
    powerups:randomSpawn(player:getX(), player:getY()) --spawns powerups randomly
    player:run(hud:get(4, 1), hud:get(2, 1)); --runs player controls, passes in joystick and fire button
    enemy:run({radar = hud:get(3, 1)}); --runs enemy logic
    powerups:run(); --runs misc. powerup animations and event listeners
    hud:run(); --runs HUD and GUI elements
  elseif(gameState == 4) then
    hud:showEndscreen();
  end
end

return gameloop;
