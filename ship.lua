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

local ship = {};
local ship_mt = {__index = ship}; --metatable

local sprite_ship = {
    type = "image",
    filename = "img/sprites/ship2.png"
}

local speed;
local maxSpeed;
local accelerationRate;
local isShooting;
local shootCooldown;
local lastAngle;
local lastMagnitude;
local bulletNum;
local bullets = {};

local debug_speedText;
local debug_shipX, debug_shipY;

--Constructor
function ship.new(_x, _y, _acceleration)
  local newShip = {
    speed = 0;
  }
  speed = 0;
  maxSpeed = 45
  accelerationRate = _acceleration;

  shootCooldown = 0;
  bulletNum = 0;
  lastAngle = 0;
  lastMagnitude = 0;

  player = display.newRect(_x, _y, 160, 267)
  player.fill = sprite_ship;

  debug_speedText = display.newText("", 1200, 300, "Arial", 72);
  debug_shipX = display.newText("", 1400, 500, "Times New Roman", 72);
  debug_shipY = display.newText("", 1400, 600, "Times New Roman", 72);

  return setmetatable(newShip, ship_mt);
end

------------------------------ Public Functions --------------------------------

--[[

  getX
    @return x
    - gets the ship's x position on the screen

  getY
    @return y
    - gets the ship's y position on the screen

  getSpeed
    @return speed
    - gets the speed of the ship

  setX
    { _x = new x coordinate of the ship}
    - sets the ship's x coordinate

  setY
    { _y = new y coordinate of the ship}
    - sets the ship's y coordinate

  setSpeed
    {_speed = new speed of ship}
    - sets the ship's new speed

  translate
    {_x = new x coordinate
     _y = new y coordinate
     _angle = angle to rotate the ship}
    - translates the ship around
    - usually used alongside the joystick in a gameloop

  run
    - runs during the game loop.
    - allows for the ship to move using the joystick.

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

function ship:getBullets()
  return bullets;
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
  physics.start()
  physics.setGravity( 0, 0 )
end

function ship:translate(_x, _y, _angle)
  player.x = player.x + _x;
  player.y = player.y + _y;
  player.rotation = _angle;
end

function ship:debug()
  debug_speedText.text = speed;
  debug_shipX.text = player.x;
  debug_shipY.text = player.y;
end

function ship:run()
  if (joystick:isInUse() == false and (speed) > 0) then
    speed = speed - accelerationRate;
    ship:translate(lastMagnitude * math.sin(math.rad(lastAngle)) * speed,
                  -lastMagnitude * math.cos(math.rad(lastAngle)) * speed,
                  lastAngle);
  elseif (joystick:isInUse() == true) then
    if (speed < maxSpeed) then
      speed = speed + accelerationRate;
    end
    ship:translate(joystick:getMagnitude() * math.sin(math.rad(joystick:getAngle())) * speed,
                  -joystick:getMagnitude() * math.cos(math.rad(joystick:getAngle())) * speed,
                  joystick:getAngle());
    lastAngle = joystick:getAngle();
    lastMagnitude = joystick:getMagnitude();
  end

  shootCooldown = shootCooldown + 1;
  if(isShooting == true and shootCooldown > 12) then
    ship:shoot();
  end
end

function ship:shoot()
  bulletNum = bulletNum + 1;
  bullets[bulletNum] = display.newRect(player.x, player.y, 25, 200);
  bullets[bulletNum]:setFillColor(0.3, 0.6, 0.9);
  bullets[bulletNum].rotation = player.rotation;
  scene:addObjectToScene(bullets[bulletNum], 2)

  physics.addBody( bullets[bulletNum], "kinematic");
  bullets[bulletNum]:setLinearVelocity(math.sin(math.rad(bullets[bulletNum].rotation))*500000, -math.cos(math.rad(bullets[bulletNum].rotation))*500000);
  shootCooldown = 0;
end



return ship;
