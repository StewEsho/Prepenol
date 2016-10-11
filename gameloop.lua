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
local radarClearTimer;
local brawlEnemyCount;
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
  radarClearTimer = 0;
  brawlEnemyCount = 101;
end

--Runs continously. Different code for each different game state
function gameloop:run()
  if(hud:getState() == 1) then --MAIN MENU--
    hud:getSelf().menuGroup.isVisible = true;
    hud:getSelf().controlGroup.isVisible = false;
    player:wander();
  elseif(hud:getState() == 2) then  --GAMEPLAY--(GAUNTLET)
    --player:debug();
    hud:getSelf().menuGroup.isVisible = false;
    hud:getSelf().controlGroup.isVisible = true;

    enemy:randomSpawn(player:getX(), player:getY(), {radar = hud:get(3, 1)}) --spawns enemies randomly
    powerups:randomSpawn(player:getX(), player:getY()) --spawns powerups randomly
    player:run(hud:get(4, 1), hud:get(2, 1)); --runs player controls, passes in joystick and fire button
    enemy:run({radar = hud:get(3, 1)}); --runs enemy logic
    powerups:run(); --runs misc. powerup animations and event listeners
    hud:run(); --runs HUD and GUI elements
  elseif(hud:getState() == 3) then--GAMEPLAY--(101 SHIP BRAWL)

    radarClearTimer = radarClearTimer + 1;
    if(radarClearTimer == 240) then
      hud:get(3, 1):clear();
      radarClearTimer = 0;
    end
    --player:debug();
    hud:getSelf().menuGroup.isVisible = false;
    hud:getSelf().controlGroup.isVisible = true;
    hud:getEnemyCounterGroup().isVisible = true;

    local enemySpawned = enemy:getAmount();
    powerups:randomSpawn(player:getX(), player:getY()) --spawns powerups randomly
    player:run(hud:get(4, 1), hud:get(2, 1)); --runs player controls, passes in joystick and fire button
    enemy:run({radar = hud:get(3, 1)}); --runs enemy logic
    powerups:run(); --runs misc. powerup animations and event listeners
    hud:run(); --runs HUD and GUI elements

    if (enemySpawned - enemy:getAmount() >= 1) then
      local enemyDiff = (enemySpawned - enemy:getAmount())
      if (brawlEnemyCount > 20) then
        enemy:batchSpawn((enemySpawned - enemy:getAmount()), {radar = hud:get(3, 1), x = player.getX(), y = player.getY()});
      end
      brawlEnemyCount = brawlEnemyCount - enemyDiff;
    end
    hud:setEnemyCounter(brawlEnemyCount);
    print( enemy:getAmount());

    if(enemy:getAmount() <= 0) then
      hud:setState(9);
    end

  elseif(hud:getState() == 4) then --GAME OVER--
    hud:showEndscreen();
    hud:getEnemyCounterGroup().isVisible = false;
  elseif(hud:getState() == 5) then --RESETTING FOR GAUNTLET
    enemy:clear(hud:get(3, 1));
    powerups:clear();
    player:reset();
    hud:setState(2);
    hud:getEnemyCounterGroup().isVisible = false;
  elseif(hud:getState() == 6) then --PREPARING FOR MENU
    enemy:clear(hud:get(3, 1));
    powerups:clear();
    player:reset();
    hud:setState(1);
    hud:getEnemyCounterGroup().isVisible = false;
  elseif(hud:getState() == 7) then --RESETTING FOR 101 SHIP BRAWL
    enemy:clear(hud:get(3, 1));
    powerups:clear();
    player:reset();
    brawlEnemyCount = 101;
    if brawlEnemyCount > 20 then
      enemy:batchSpawn(20, {radar = hud:get(3, 1)});
    else
      enemy:batchSpawn(5, {radar = hud:get(3, 1)});
    end
    hud:getEnemyCounterGroup().isVisible = true;
    hud:setState(3);
  elseif(hud:getState() == 8) then --GAME OVER AFTER BRAWL--
    hud:showEndscreen();
    hud:getEnemyCounterGroup().isVisible = false;
  elseif(hud:getState() == 9) then --Victory AFTER BRAWL--
    hud:showVictoryScreen();
    hud:getEnemyCounterGroup().isVisible = false;
  end

  if(player:getIsDead()) then
    if(hud:getState() == 2) then hud:setState(4);
    elseif(hud:getState() == 3) then hud:setState(8); end
  end

end

return gameloop;
