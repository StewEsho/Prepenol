--------------------------------------------------------------------------------
--
-- Controls the player and their ship
--
-- ship.lua
--
------------------------------- Private Fields ---------------------------------

local ship = {};
local ship_mt = {}; --metatable

local x = 0;
local y = 0;
local isShooting = false;

------------------------------ Public Functions --------------------------------

--Constructor
function ship.new(_x, _y)
  local newShip = {
    x = _x;
    y = _y;
  }

  display.newRect(_x, _y, 300, 300)

  return setmetatable(newShip, ship_mt);
end

function ship:getX()
  return x;
end

function ship:getY()
  return y;
end

function ship:setX(_x)
  x = _x;
end

function ship:setY(_y)
  y = _y;
end

function ship:translate(_x, _y)
  x = x + _x;
  y = y + _y;
end

return ship;
