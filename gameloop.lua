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

local kek

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
local kek;
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
  --enemy:spawn(1);
  --enemy:spawn(2, -200, -500);
  --enemy:spawn(1);
  --enemy:spawn(2, math.random(-1000, 1000), math.random(-1000, 1000));
  --enemy:spawn(2, math.random(-1000, 1000), math.random(-1000, 1000));
  --enemy:spawn(2, math.random(-1000, 1000), math.random(-1000, 1000));
  --enemy:spawn(2, math.random(-1000, 1000), math.random(-1000, 1000));

  kek = display.newText(enemy:get(1,1).health, 200, 200, "Arial", 48)

  --Spawns in HUD and Controls
  stick = joystick.new(1.125 * display.contentWidth/8, 6 * display.contentHeight / 8);
  fireBttn = button.new(display.contentWidth - (display.contentHeight/4),  --x
                        display.contentHeight-(display.contentHeight/6),   --y
                        display.contentHeight/2, display.contentHeight/3,  --width, height
                        true,     --toggleable?
                        1,      --red
                        0.6,      --green
                        0.6,     --blue
                        0.5,     --alpha
                        "fire");  --tag
  fireBttn:init();
  stick:init();
end

--Runs continously. Different code for each different game state
function gameloop:run()
  player:run();
  --player:debug();

  kek.text = enemy:get(1,1).health

  for i = 1, table.getn(enemy:get()) do
    for j = 1, table.getn(enemy:get(i)) do
      enemy:get(i,j):run();
    end
  end

  if (fireBttn:isPressed() == true) then
    player:setIsShooting(true);
  else
    player:setIsShooting(false);
  end
end

return gameloop;
