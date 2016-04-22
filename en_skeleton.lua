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
  instance.index = index;
  instance.layer = _layer or 1;

  instance.width = 160;
  instance.height = 200;
  instance.sprite = display.newRect(instance.x, instance.y, instance.width, instance.height);
  instance.speed = 0;
  instance.enemyType = 1; --skeleton
  instance.canShoot = true;
  instance.maxSpeed = 42;
  instance.acceleration = 1;
  instance.isDead = false;

  --Used for shaking the object when hit
  instance.sprite.shakeMax = 15;
  instance.sprite.shakeAmount = 0;
  instance.sprite.isShaking = false;

  instance.sprite.health = 30;
  instance.sprite.armour = math.random(10, 13);
  instance.sprite.name = "Skeleship";
  instance.sprite.description = "Fast and lightweight, Skeleships will weave through the brightest stars for their bounty.";

  return setmetatable(instance, skeleton);
end

function skeleton:shake()
  if(self.sprite.isShaking == true) then
    if(self.sprite.shakeMax <= 1) then
      self.sprite.shakeMax = 15;
      self.sprite.isShaking = false;
    else
      self.sprite.shakeAmount = math.random(self.sprite.shakeMax);
      self.sprite.x = self.x + math.random(-self.sprite.shakeAmount, self.sprite.shakeAmount);
      self.sprite.y = self.y + math.random(-self.sprite.shakeAmount, self.sprite.shakeAmount);
      self.sprite.shakeMax = self.sprite.shakeMax - 0.85;
    end
  end
end

function skeleton:kill()
  self.sprite:removeSelf();
end

function skeleton:init()
  self.sprite.fill = {type = "image", filename = "img/sprites/skel.jpg"};
  physics.addBody(self.sprite, "kinematic");
  scene:addObjectToScene(self.sprite, self.layer);
end

function skeleton:run()
  if (self.sprite.health <= 0) then
    self.isDead = true;
  else
    self:shake();
    self.x = self.x + 0.25;
    if(self.sprite.isShaking == false) then
      self.sprite.x = self.x;
      self.sprite.y = self.y;
    end
  end
end

return skeleton;
