--------------------------------------------------------------------------------
--
-- ENEMY: Skeleship
--
-- en_skeleton.lua
--
------------------------------- Private Fields ---------------------------------
local scene = require("scene");
local player = require("ship");

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

  --Used for shaking the object when hit
  instance.shakeMax = 15;
  instance.shakeAmount = 0;
  instance.isShaking = false;
  instance.kek = display.newText(instance.shakeMax, 300, 300, "Arial", 36);

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

function skeleton:enableShake()
  self.isShaking = true;
end

function skeleton:shake()
  if(self.isShaking == true) then
    if(self.shakeMax <= 1) then
      self.shakeMax = 15;
      self.isShaking = false;
    else
      self.shakeAmount = math.random(self.shakeMax);
      self.x = self.x + math.random(-self.shakeAmount, self.shakeAmount);
      self.y = self.y + math.random(-self.shakeAmount, self.shakeAmount);
      self.shakeMax = self.shakeMax - 0.85;
      self.kek.text = self.shakeMax;
    end
  end
end

function skeleton:init()
  self.sprite.fill = {type = "image", filename = "img/sprites/skel.jpg"};
  scene:addObjectToScene(self.sprite, self.layer);
end

function skeleton:run()
  if (math.abs(player:getX() - self.x) < 50 or math.abs(player:getY() - self.y) < 50) then
    self.isShaking = true;
  end

  self:shake();
  self.sprite.x = self.x;
  self.sprite.y = self.y;
end

return skeleton;
