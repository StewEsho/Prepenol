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

  --Used for shaking the object when hit
  instance.shakeMax = 15;
  instance.shakeAmount = 0;
  instance.isShaking = false;

  instance.enemyType = 1; --skeleton
  instance.canShoot = true;
  instance.maxSpeed = 42;
  instance.acceleration = 1;
  instance.health = 30;
  instance.armour = math.random(1, 3);
  instance.name = "Skeleships";
  instance.description = "Fast and lightweight, Skeleships will weave through the brightest stars for their bounty.";

  return setmetatable(instance, skeleton);
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
    end
  end
end

function skeleton:init()
  self.sprite.fill = {type = "image", filename = "img/sprites/skel.jpg"};
  physics.addBody(self.sprite, "kinematic");
  scene:addObjectToScene(self.sprite, self.layer);
end

function skeleton:run()
  if self.health <= 0 then
    self.sprite:removeSelf();

  else
    self:shake();
    self.sprite.x = self.x;
    self.sprite.y = self.y;
  end
end

return skeleton;
