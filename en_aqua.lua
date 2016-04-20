--------------------------------------------------------------------------------
--
-- ENEMY: Aquae
--
-- en_aqua.lua
--
------------------------------- Private Fields ---------------------------------
local scene = require("scene");

aqua = {};
aqua.__index = aqua;
------------------------------ Public Functions --------------------------------

function aqua.new(_x, _y, _index, _layer)
  local instance = {
  }

  instance.x = _x or math.random(-1000, 1000);
  instance.y = _y or math.random(-1000, 1000);
  instance.index = _index;
  instance.layer = _layer or 1;

  instance.width = math.random(100, 500);
  instance.height = math.random(100, 500);
  instance.sprite = display.newRect(instance.x, instance.y, instance.width, instance.height);
  instance.speed = 0;

  instance.properties = {
    enemyType = 2, --aqua
    canShoot = true,
    maxSpeed = 20,
    acceleration = 0.6,
    health = 60,
    name = "Skeleships",
    description = "Careful: Aquaes won't restrict themselves to one shape or size."
  }

  return setmetatable(instance, aqua);
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
  self.sprite.fill = {type = "image", filename = "img/sprites/aqua.png"};
  scene:addObjectToScene(self.sprite, self.layer);
end

function aqua:run()
  self.x = self.sprite.x;
  self.y = self.sprite.y;
  self.width = self.sprite.width;
  self.height = self.sprite.height;
end

return aqua;
