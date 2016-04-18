--------------------------------------------------------------------------------
--
-- Controls the basic, common logic of enemies
--
-- skeleton.lua
--
------------------------------- Private Fields ---------------------------------
skeleton = {};
skeleton_mt = {__index = skeleton}; --metatable

local x,y
local width, height;
local maxSpeed;
local acceleration;
local sprite;

local speed;

------------------------------ Public Functions --------------------------------

function skeleton.new( _x, _y)
  local newSkeleton = {
  }

  x = _x or math.random(-1000, 1000);
  y = _y or math.random(-1000, 1000);
  width = 160
  height = 200
  maxSpeed = 50
  acceleration = 0.75;

  sprite = display.newRect(x, y, width, height);

  speed = 0;

  return setmetatable(newSkeleton, skeleton_mt);
end

function skeleton:getSpeed()
  return speed;
end

function skeleton:getX()
  return x;
end

function skeleton:getY()
  return y;
end

function skeleton:getDisplayObject()
  return sprite;
end

function skeleton:init(_filepath)
  sprite.fill = {type = "image", filename = _filepath}
end

function skeleton:run()
  x = sprite.x;
  y = sprite.y;
  width = sprite.width;
  height = sprite.height;
end

return skeleton;
