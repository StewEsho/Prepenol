--------------------------------------------------------------------------------
--
-- Skeleton enemy
-- Inherited from enemy.lua
--
-- en_skeleton.lua
--
------------------------------- Private Fields ---------------------------------
require ("enemy")

local skeleton = {};
skeleton.__index = skeleton;

local x,y
local width, height;
local maxSpeed;
local acceleration;
local sprite;

local speed;

------------------------------ Public Functions --------------------------------

function skeleton.new(_x, _y,
                      _width, _height,
                      _maxSpeed,
                      _acceleration)
  local newSkeleton = {
    x = _x or 0;
    y = _y or 0;
    width = _width or 256;
    height = _height or 256;
    maxSpeed = _maxSpeed or 50;
    acceleration = _acceleration or 0.75;

    speed = 0;
  }

  setmetatable(newSkeleton, skeleton);
  return newSkeleton;
end
setmetatable(skeleton, {__index = enemy})

return skeleton;
