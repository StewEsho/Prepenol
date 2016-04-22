--------------------------------------------------------------------------------
--
-- ENEMY: Aquae
--
-- en_aqua.lua
--
------------------------------- Private Fields ---------------------------------
local scene = require("scene");
local physics = require("physics");

aqua = {};
aqua.__index = aqua;
------------------------------ Public Functions --------------------------------

function aqua.new(_x, _y, _index, _layer)
  local instance = {
  }

  instance.x = _x or math.random(-1000, 1000);
  instance.y = _y or math.random(-1000, 1000);
  instance.index = index;
  instance.layer = _layer or 1;
  --------
  instance.width = math.random(100, 500);
  instance.height = math.random(100, 500);
  instance.speed = 0;
  instance.enemyType = 1; --skeleton
  instance.canShoot = true;
  instance.maxSpeed = 25;
  instance.acceleration = 0.45;
  instance.isDead = false;

  instance.sprite = display.newRect(instance.x, instance.y, instance.width, instance.height);
  instance.sprite.health = 70;
  instance.sprite.armour = 15;
  instance.sprite.name = "Aquae";
  instance.sprite.description = "Careful: Aquaes won't restrict themselves to one shape or size.";
  --Used for shaking the object when hit
  instance.sprite.shakeMax = 15;
  instance.sprite.shakeAmount = 0;
  instance.sprite.isShaking = false;

  return setmetatable(instance, aqua);
end

function aqua:shake()
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

function aqua:kill()
  self.sprite:removeSelf();
end

function aqua:init()
  self.sprite.fill = {type = "image", filename = "img/sprites/aqua.png"};
  physics.addBody(self.sprite, "kinematic");
  scene:addObjectToScene(self.sprite, self.layer);
end

function aqua:run()
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

return aqua;
