--------------------------------------------------------------------------------
--
-- Controls the player and their ship
--
-- ship.lua
--
------------------------------- Private Fields ---------------------------------

local joystick = require ("joystick");

local ship = {};
local ship_mt = {}; --metatable

local sprite_ship = {
    type = "image",
    filename = "Ship.png"
}

local x;
local y;
local speed;
local isShooting;

--Constructor
function ship.new(_x, _y, _speed)
  local newShip = {
    x = _x;
    y = _y;
    speed = _speed;
  }

  x = _x;
  y = _y;
  speed = _speed;

  player = display.newRect(_x, _y, 240, 400)
  player.fill = sprite_ship;

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

function ship:getX()
  return x;
end

function ship:getY()
  return y;
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

function ship:setSpeed(_speed)
  speed = _speed;
end

function ship:translate(_x, _y, _angle)
  player.x = player.x + _x;
  player.y = player.y + _y;
  player.rotation = _angle;
end

function ship:run()
  ship:translate(joystick:getMagnitude() * math.sin(math.rad(joystick:getAngle())) * ship:getSpeed(),
                -joystick:getMagnitude() * math.cos(math.rad(joystick:getAngle())) * ship:getSpeed(),
                joystick:getAngle());
end

return ship;
