--------------------------------------------------------------------------------
--
-- Controls the player and their ship
--
-- ship.lua
--
------------------------------- Private Fields ---------------------------------

local joystick = require ("joystick");
local physics = require ("physics");
local scene = require ("scene")
local bullets = require ("bullets");
local enemy = require("enemies");

local ship = {};
local ship_mt = {__index = ship}; --metatable

local sprite_ship = {
    type = "image",
    filename = "img/sprites/ship.png"
}

local width, length;
local speed, currentSpeed, maxSpeed;
local accelerationRate;
local isShooting;
local shootCooldown;
local turnRateAngleDiff;
local lastAngle;
local lastMagnitude;

local debug_speedText;
local debug_currentSpeed;
local debug_shipX, debug_shipY;
local debug_bulletNum;

--Constructor
function ship.new(_x, _y, _acceleration)
  local newShip = {
  }

  speed = 0;
  currentSpeed = 0;
  maxSpeed = 50;
  accelerationRate = _acceleration;

  shootCooldown = 0;
  bulletNum = 0;
  bulletCount = 1;
  lastAngle = 0;
  lastMagnitude = 0;
  width = 92;
  length = 153.5;

  player = display.newRect(_x, _y, width, length);
  player.fill = sprite_ship;
  player.name = "Player";
  player.health = 100;
  player.maxHealth = 100;

  healthBar = display.newRect(_x, _y - 100, 150, 20);
  healthBar:setFillColor(50/255, 100/255, 255/255);
  healthMissing = display.newRect(_x, _y - 100, 150, 20);
  healthMissing:setFillColor(255/255, 100/255, 60/255);

  bullets.new(player);

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
  return speed;
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
  speed = _speed;
end

function ship:setAcceleration(_acceleration)
  accelerationRate = _acceleration;
end

function ship:init()
  bullets:init();
  scene:addObjectToScene(player, 0);
  scene:addObjectToScene(healthMissing, 0);
  scene:addObjectToScene(healthBar, 0);
  scene:addFocusTrack(player);
  healthBar.x = player.x - ((healthMissing.width - healthBar.width)/2);
end

function ship:translate(_x, _y, _angle)
  player.x = player.x + _x;
  player.y = player.y + _y;

  turnRateAngleDiff = (player.rotation - _angle + 180) % 360 - 180;

  if (turnRateAngleDiff > speed/2) then
    player.rotation = player.rotation - speed/2;
  elseif (turnRateAngleDiff < -speed/2) then
    player.rotation = player.rotation + speed/2;
  else
    player.rotation = _angle;
  end
end

function ship:debug()
  debug_speedText.text = speed;
  debug_shipX.text = player.x;
  debug_shipY.text = player.y;
  debug_currentSpeed.text = currentSpeed;
end

function ship:run()

  healthBar.width = (player.health/player.maxHealth)*healthMissing.width;

  healthBar.y = player.y - 100 - currentSpeed * math.cos(math.rad(lastAngle));
  healthBar.x = player.x - ((healthMissing.width - healthBar.width)/2) + currentSpeed * math.sin(math.rad(lastAngle));
  healthMissing.y = player.y - 100 -currentSpeed * math.cos(math.rad(lastAngle));
  healthMissing.x = player.x + currentSpeed * math.sin(math.rad(lastAngle));

  if (joystick:isInUse() == false and (speed) > 0) then
    speed = speed - accelerationRate;
    currentSpeed = speed;

    ship:translate(lastMagnitude * math.sin(math.rad(lastAngle)) * speed,
                  -lastMagnitude * math.cos(math.rad(lastAngle)) * speed,
                  lastAngle);

  elseif (joystick:isInUse() == true) then
    if (speed < maxSpeed) then
      speed = speed + (accelerationRate * joystick:getMagnitude());
    end
    currentSpeed = joystick:getMagnitude() * speed;
    ship:translate(currentSpeed * math.sin(math.rad(joystick:getAngle())),
                  -currentSpeed * math.cos(math.rad(joystick:getAngle())),
                  joystick:getAngle());
    lastAngle = joystick:getAngle();
    lastMagnitude = joystick:getMagnitude();
  end

  shootCooldown = shootCooldown + 1;
  if(isShooting == true and shootCooldown > (8)) then
    bullets:shoot();
    shootCooldown = 0;
  end
  bullets:removeBullets();
end

return ship;
