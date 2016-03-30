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

local x;
local y;
local speed;
local isShooting;

------------------------------ Public Functions --------------------------------

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

  player = display.newRect(_x, _y, 300, 400)

  return setmetatable(newShip, ship_mt);
end

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
