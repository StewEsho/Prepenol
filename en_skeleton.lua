--------------------------------------------------------------------------------
--
-- Controls the basic, common logic of enemies
--
-- skeleton.lua
--
------------------------------- Private Fields ---------------------------------
skeleton = {};
skeleton.__index = skeleton;
------------------------------ Public Functions --------------------------------

function skeleton.new( _x, _y, index)
  local newSkeleton = {
  }

  newSkeleton.x = _x or math.random(-1000, 1000);
  newSkeleton.y = _y or math.random(-1000, 1000);
  newSkeleton.width = 160
  newSkeleton.height = 200
  newSkeleton.maxSpeed = 50
  newSkeleton.acceleration = 0.75;
  newSkeleton.sprite = display.newRect(newSkeleton.x, newSkeleton.y, newSkeleton.width, newSkeleton.height);
  newSkeleton.speed = 0;

  newSkeleton.index = index;
  newSkeleton.enemyType = 1; --skeleton

  return setmetatable(newSkeleton, skeleton);
end

function skeleton:getSpeed()
  return self.speed;
end

function skeleton:getX()
  return self.x;
end

function skeleton:getY()
  return self.y;
end

function skeleton:getDisplayObject()
  return self.sprite;
end

function skeleton:init(_filepath)
  self.sprite.fill = {type = "image", filename = _filepath}
end

function skeleton:run()
  self.x = self.sprite.x;
  self.y = self.sprite.y;
  self.width = self.sprite.width;
  self.height = self.sprite.height;
end

return skeleton;
