--------------------------------------------------------------------------------
--
-- Base Enemy class
--
-- baseEnemy.lua
--
------------------------------- Private Fields ---------------------------------
local scene = require("scene");
local class = require("classy");

local M = {}

M.BaseEnemy = class("BaseEnemy");

function M.BaseEnemy:__init(_enemyType, _x, _y, _width, _height, _spriteImg, _name, _description, _layer)
  self.x = _x or math.random(-1000, 1000);
  self.y = _y or math.random(-1000, 1000);
  self.sprite = display.newRect(self.x, self.y, _width, _height);
  if (_spriteImg ~= nil) then
    self.sprite.fill = {type = "image", filename = _spriteImg};
  end
  self.sprite.enemyType = _enemyType; --base class

  self.sprite.name = _name or "BaseEnemy";
  self.sprite.description = _description or "Base Description";
  self.layer = _layer or 1;

  self.sprite.shakeMax = 15;
  self.sprite.shakeAmount = 0;
  self.sprite.isShaking = false;

  scene:addObjectToScene(self.sprite, self.layer);
end

function M.BaseEnemy:shake()
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

function M.BaseEnemy:kill()
  self.sprite:removeSelf();
end

function M.BaseEnemy:isDead()
  if(self.sprite ~= nil) then
    return false;
  else
    return true;
  end
end

function M.BaseEnemy:run()
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

return M;
