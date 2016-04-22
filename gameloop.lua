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
local enemies = require("enemies");
local bullets = require("bullets");

local kek;

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
local testEn;
local enemy;
------------------------------ Public Functions --------------------------------

--Runs once to initialize the game
--Runs again everytime the game state changes
function gameloop:init()
  --initializes system variables and settings
  math.randomseed(os.time());
  display.setDefault( "background", 30/255, 15/255, 27/255);
  system.activate( "multitouch" );
  native.setProperty( "androidSystemUiVisibility", "immersiveSticky" );

  --sets gamestate
  gameState = 2;

  --creates instances of classes
  enemy = enemies.new();
  player = ship.new(0, 0, 0.75);
  --initializes instances
  scene:init(1);
  player:init();

  --initializes scene
  scene:addObjectToScene(player:getDisplayObject(), 0);
  scene:addFocusTrack(player:getDisplayObject());

  --Spawns in enemies
  enemy:spawn(1, 0, -500);
  enemy:spawn(1);
  enemy:spawn(2);
  enemy:spawn(2);
  enemy:spawn(1);
  enemy:spawn(1);
  enemy:spawn(1);
  enemy:spawn(1);

  --Spawns in HUD and Controls
  stick = joystick.new(1.125 * display.contentWidth/8, 6 * display.contentHeight / 8);
  fireBttn = button.new(display.contentWidth - (display.contentHeight/4),  --x
                        display.contentHeight-(display.contentHeight/6),   --y
                        display.contentHeight/2, display.contentHeight/3,  --width, height
                        false,     --toggleable?
                        1,      --red
                        0.6,      --green
                        0.6,     --blue
                        0.5,     --alpha
                        "fire");  --tag
  fireBttn:init();
  stick:init();

end
local kek = 0;
--Runs continously. Different code for each different game state
function gameloop:run()
  if (kek < 60) then
    kek = kek + 1;
  else
    kek = 0;
    if (table.getn(enemy:get(1)) + table.getn(enemy:get(2)) < 20) then
      enemy:spawn(math.random(1,2));
    end
  end
  player:run();
  --player:debug();

  for i = 1, table.getn(enemy:get()) do
    for j = 1, table.getn(enemy:get(i)) do
      if (enemy:get(i,j) == nil) then break
      elseif (enemy:get(i,j).isDead == true) then
        enemy:get(i,j):kill();
        table.remove(enemy:get(i), j);
      end
    end
  end

  for k = 1, table.getn(enemy:get()) do
    for l = 1, table.getn(enemy:get(k)) do
      enemy:get(k,l):run();
    end
  end

  if (fireBttn:isPressed() == true) then
    player:setIsShooting(true);
  else
    player:setIsShooting(false);
  end
end

return gameloop;
