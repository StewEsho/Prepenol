--------------------------------------------------------------------------------
--
-- ENEMY: Skeleship
--
-- en_skeleton.lua
--
------------------------------- Private Fields ---------------------------------
local scene = require("scene");

skeleton = {};
skeleton.__index = skeleton;
------------------------------ Public Functions --------------------------------

function skeleton.new( _x, _y, index, _layer)
  local instance = {
  }

  instance.x = _x or math.random(-1000, 1000);
  instance.y = _y or math.random(-1000, 1000);
  instance.layer = _layer or 1;
  instance.index = index;

  instance.width = 160;
  instance.height = 200;
  instance.sprite = display.newRect(instance.x, instance.y, instance.width, instance.height);
  instance.speed = 0;

  instance.properties = {
    enemyType = 1, --skeleton
    canShoot = true,
    maxSpeed = 42,
    acceleration = 1,
    health = 30,
    name = "Skeleships",
    description = "Fast and lightweight, Skeleships will weave through the brightest stars for their bounty."
  }

  return setmetatable(instance, skeleton);
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

function skeleton:getDescription()
  return self.properties.description;
end

function skeleton:init()
  self.sprite.fill = {type = "image", filename = "img/sprites/skel.jpg"};
  scene:addObjectToScene(self.sprite, self.layer);
end

function skeleton:run()
  self.x = self.sprite.x;
  self.y = self.sprite.y;
  self.width = self.sprite.width;
  self.height = self.sprite.height;
end

return skeleton;
