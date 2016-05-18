--------------------------------------------------------------------------------
--
-- Controls the player and their ship
--
-- ship.lua
--
------------------------------- Private Fields ---------------------------------

local joystick = require ("joystick");
local button = require ("button");
local physics = require ("physics");
local scene = require ("scene")
local bullet = require ("bullets");

local ship = {};
local ship_mt = {__index = ship}; --metatable

local sprite_ship = {
    type = "image",
    filename = "img/sprites/ship.png"
}

local width, length;
local speed, currentSpeed;
local accelerationRate;
local isShooting;
local shootCooldown;
local turnRateAngleDiff;
local lastAngle;
local lastMagnitude;
local gameOverBackground;

local debug_speedText;
local debug_currentSpeed;
local debug_shipX, debug_shipY;
local debug_bulletNum;

local bullets;
local collisionID;

--Constructor
function ship.new(_x, _y, _acceleration)
  local newShip = {
  }


  currentSpeed = 0;

  accelerationRate = _acceleration;

  shootCooldown = 0;
  bulletNum = 0;
  bulletCount = 1;
  lastAngle = 0;
  lastMagnitude = 0;
  width = 69;
  length = 115.125;

  player = display.newRect(_x, _y, width, length);

  player.healthBar = display.newRect(_x, _y - 100, 150, 20);
  player.healthBar:setFillColor(50/255, 100/255, 255/255);
  player.healthMissing = display.newRect(_x, _y - 100, 150, 20);
  player.healthMissing:setFillColor(255/255, 100/255, 60/255);

  player.fill = sprite_ship;
  player.name = "Player";
  player.healthBar.health = 1000;
  player.healthBar.armour = 0;
  player.healthBar.maxHealth = 1000;
  player.damage = nil;
  player.bulletDamage = 4;
  player.damageTimeout = 0;
  player.maxSpeed = 35;
  player.speed = 0;
  player.isDead = false;

  --stores the cooldowns on the buffs gained by most powerups
  --counts down; 0 means cooldown is done
  --[[
    [1] --> speedBoost
    [2] --> double Damage
  ]]
  player.powerupBuffs = {
    -1,
    -1
  }

  collisionID = 1;
  physics.addBody( player, "kinematic", {filter = { categoryBits = collisionID, maskBits=23 }});
  player.isFixedRotation = true;
  player.gravityScale = 0;

  bullets = bullet.newInstance(player, "img/sprites/bullet-player.png", player.width/6);

  debug_speedText = display.newText("", 1200, 300, "Arial", 72);
  debug_currentSpeed = display.newText("", 500, 300, "Arial", 72);
  debug_shipX = display.newText("", 1400, 500, "Times New Roman", 72);
  debug_shipY = display.newText("", 1400, 600, "Times New Roman", 72);
  debug_bulletNum = display.newText("", 500, 900, "Courier", 72);

  return setmetatable(newShip, ship_mt);
end

------------------------------ Public Functions --------------------------------

--[[

  getDisplayObject
    @return player
    - returns the display object / sprite of the ship
    - used for camera tracking

  getX
    @return x
    - gets the ship's x position on the screen

  getY
    @return y
    - gets the ship's y position on the screen

  getSpeed
    @return speed
    - gets the speed of the ship

  getBullets
    @return bullets
    - gets the table containing all shot bullets

  setIsShooting
    ( _flag = boolean to set isShooting as)
    - used to toggle shooting on or off

  setX
    ( _x = new x coordinate of the ship)
    - sets the ship's x coordinate

  setY
    ( _y = new y coordinate of the ship)
    - sets the ship's y coordinate

  setSpeed
    (_speed = new speed of ship)
    - sets the ship's new speed

  setAcceleration
    (_acceleration = new accelerationRate of ship)
    - sets the acceleartion and decceleration rate of the ship (in pixels per 1/60th of a second squared)

  init
    - runs once at the beginning of the game loop
    - used to initiate the physics engine

  translate
    (_x = new x coordinate
     _y = new y coordinate
     _angle = angle to rotate the ship)
    - translates the ship around
    - usually used alongside the joystick in a gameloop

  debug
    - sets the gui texts as important info, such as coordinates or speed
    - mainly used to debug game during development

  run
    - runs during the game loop.
    - allows for the ship to move using the joystick.

  shoot
    - controlls the shooting of bullets
    - adds bullets to a table containing all bullets

]]--

function ship:getGameOverBG()
  return gameOverBackground;
end

function ship:isDead()
  return player.isDead;
end

function ship:getDisplayObject()
  return player;
end

function ship:getX()
  return player.x;
end

function ship:getY()
  return player.y;
end

function ship:getSpeed()
  return player.speed;
end

function ship:setX(_x)
  x = _x;
end

function ship:setY(_y)
  y = _y;
end

function ship:setIsShooting(_flag)
  isShooting = _flag;
end

function ship:setSpeed(_speed)
  player.speed = _speed;
end

function ship:setAcceleration(_acceleration)
  accelerationRate = _acceleration;
end

function ship.damage(_damage)
  if(player.damageTimeout <= 275) then
    player.healthBar.health = player.healthBar.health - _damage;
    player.damageTimeout = 300;
  end
end

function ship:updateBuffs()
  for k = 1, table.getn(player.powerupBuffs) do
    player.powerupBuffs[k] = player.powerupBuffs[k] - 1;
    if(player.powerupBuffs[k] == 0) then
      if(k == 1) then
        player.maxSpeed = 35;
        player.speed = 35;
      elseif(k == 2) then
        player:setFillColor(1,1,1)
        player.bulletDamage = player.bulletDamage / 2;
      end
    end
  end
end

function ship:translate(_x, _y, _angle)
  player.x = player.x + _x;
  player.y = player.y + _y;

  turnRateAngleDiff = (player.rotation - _angle + 180) % 360 - 180;

  if (turnRateAngleDiff > player.speed/4) then
    player.rotation = player.rotation - player.speed/4;
  elseif (turnRateAngleDiff < -player.speed/4) then
    player.rotation = player.rotation + player.speed/4;
  else
    player.rotation = _angle;
  end
end

function ship:initHUD()
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

function ship:getStick()
  return stick;
end

function ship:getButton()
  return fireBttn;
end

function ship:init()
  player.damage = ship.damage;
  scene:addObjectToScene(player, 0);
  scene:addObjectToScene(player.healthMissing, 0);
  scene:addObjectToScene(player.healthBar, 0);
  scene:addFocusTrack(player);
  player.healthBar.x = player.x - ((player.healthMissing.width - player.healthBar.width)/2);
end

function ship:run() --Runs every frame
  if(player.healthBar.health <= 0) then
    player.isDead = true;
    gameOverBackground = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight);
    gameOverBackground = display.newRect(display.contentWidth/2, display.contentHeight/2, display.actualContentWidth, display.actualContentHeight);
    gameOverBackground:setFillColor(0.8, 0.1, 0.2, 1);
    gameOverBackground.alpha = 0;
  else
    ship:updateBuffs();
    --Updates the healthbar
    player.healthBar.width = (player.healthBar.health/player.healthBar.maxHealth)*player.healthMissing.width;
    --Moves the healthbar with the player
    player.healthBar.y = player.y - 100 - player.speed * lastMagnitude * math.cos(math.rad(lastAngle));
    player.healthBar.x = player.x - ((player.healthMissing.width - player.healthBar.width)/2) + player.speed * lastMagnitude * math.sin(math.rad(lastAngle));
    player.healthMissing.y = player.y - 100 - player.speed * lastMagnitude * math.cos(math.rad(lastAngle));
    player.healthMissing.x = player.x + player.speed * lastMagnitude * math.sin(math.rad(lastAngle));

    if (fireBttn:isPressed() == true) then
      isShooting = true;
    else
      isShooting = false;
    end

    if (joystick:isInUse() == false and (player.speed) > 0) then
      player.speed = player.speed - accelerationRate;
      currentSpeed = player.speed;

      ship:translate(lastMagnitude * math.sin(math.rad(lastAngle)) * player.speed,
                    -lastMagnitude * math.cos(math.rad(lastAngle)) * player.speed,
                    lastAngle);

    elseif (joystick:isInUse() == true) then
      player:setLinearVelocity(0, 0);
      player:applyTorque(0);
      if (player.speed < player.maxSpeed) then
        player.speed = player.speed + (accelerationRate * joystick:getMagnitude());
      end
      currentSpeed = joystick:getMagnitude() * player.speed;
      ship:translate(currentSpeed * math.sin(math.rad(joystick:getAngle())),
                    -currentSpeed * math.cos(math.rad(joystick:getAngle())),
                    joystick:getAngle());
      lastAngle = joystick:getAngle();
      lastMagnitude = joystick:getMagnitude();
    end

    bullets:removeBullets();
    shootCooldown = shootCooldown + 1;
    if(isShooting == true and shootCooldown > (8)) then
      bullets:shoot(4);
      bullets:shoot(4, 2 - (currentSpeed/36.5));
      bullets:shoot(4, -2 + (currentSpeed/36.5));
      shootCooldown = 0;
    end

    if(player.damageTimeout <= 299) then
      player.isVisible = true;
    else
      player.isVisible = not player.isVisible;
    end

    player.damageTimeout = player.damageTimeout - 1;
    if(player.damageTimeout <= 0 and player.healthBar.health < player.healthBar.maxHealth) then
      player.healthBar.health = player.healthBar.health + 1;
    end

    player.x = player.x;
    player.y = player.y;
  end
end

function ship:debug()
  debug_speedText.text = player.speed;
  debug_shipX.text = player.x;
  debug_shipY.text = player.y;
  debug_currentSpeed.text = currentSpeed;
  print(player.health)
end

return ship;
