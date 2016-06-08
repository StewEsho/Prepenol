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

  --creates instances of classes
  enemy = enemies.new();
  player = ship.new(0, 0, 0.75);
  powerups = powerup.class();

  --initializes instances
  scene:init(1);
  player:init();

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
  if(hud:getState() == 1) then --MAIN MENU--
    hud:getSelf().menuGroup.isVisible = true;
    hud:getSelf().controlGroup.isVisible = false;
    player:wander();
  elseif(hud:getState() == 2) then  --GAMEPLAY--
    --player:debug();
    hud:getSelf().menuGroup.isVisible = false;
    hud:getSelf().controlGroup.isVisible = true;

    enemy:randomSpawn(player:getX(), player:getY(), {radar = hud:get(4, 1)}) --spawns enemies randomly
    powerups:randomSpawn(player:getX(), player:getY()) --spawns powerups randomly
    player:run(hud:get(4, 1), hud:get(2, 1)); --runs player controls, passes in joystick and fire button
    enemy:run({radar = hud:get(3, 1)}); --runs enemy logic
    powerups:run(); --runs misc. powerup animations and event listeners
    hud:run(); --runs HUD and GUI elements
  elseif(hud:getState() == 4) then --GAME OVER--
    hud:showEndscreen();
  elseif(hud:getState() == 5) then --RESETTING
    enemy:clear(hud:get(3, 1));
    powerups:clear();
    player:reset();
    hud:setState(2);
  elseif(hud:getState() == 6) then --PREPARING FOR MENU
    enemy:clear(hud:get(3, 1));
    powerups:clear();
    player:reset();
    hud:setState(1);
  end

  if(player:getIsDead() and hud:getState() == 2) then
    hud:setState(4);
  end
end

return gameloop;
