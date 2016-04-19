--------------------------------------------------------------------------------
--
-- Controls the basic, common logic of enemies
--
-- en_aqua.lua
--
------------------------------- Private Fields ---------------------------------
aqua = {};
aqua.__index = aqua;
------------------------------ Public Functions --------------------------------

function aqua.new(_x, _y, _index)
  local newAqua = {
  }

  newAqua.x = _x or math.random(-1000, 1000);
  newAqua.y = _y or math.random(-1000, 1000);
  newAqua.width = math.random(100, 500);
  newAqua.height = math.random(100, 500);
  newAqua.maxSpeed = 50
  newAqua.acceleration = 0.75;
  newAqua.sprite = display.newRect(newAqua.x, newAqua.y, newAqua.width, newAqua.height);
  newAqua.speed = 0;

  newAqua.index = _index;
  newAqua.enemyType = 1; --aqua

  return setmetatable(newAqua, aqua);
end

function aqua:getSpeed()
  return self.speed;
end

function aqua:getX()
  return self.x;
end

function aqua:getY()
  return self.y;
end

function aqua:getDisplayObject()
  return self.sprite;
end

function aqua:init()
  self.sprite.fill = {type = "image", filename = "img/sprites/aqua.png"}
end

function aqua:run()
  self.x = self.sprite.x;
  self.y = self.sprite.y;
  self.width = self.sprite.width;
  self.height = self.sprite.height;
end

return aqua;
