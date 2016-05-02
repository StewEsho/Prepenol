--------------------------------------------------------------------------------
--
-- ENEMY: Fireball
--
-- en_fire.lua
--
------------------------------- Private Fields ---------------------------------
local enemyBase = require("baseEnemy");
local class = require("classy");
local player = require("ship");
local physics = require("physics");
physics.start();

local M = {};

M.class = class("Fireballer", enemyBase.BaseEnemy);
M.description = "These guys are bringing and packing the heat."

function M.class:__init(_x, _y)
  self.x = _x;
  self.y = _y;
  enemyBase.BaseEnemy.__init(self, 3, self.x, self.y, 175, 250, math.random(0, 359), "img/sprites/fire.jpg", "Fireballer", description, 1);

  self.sprite.maxSpeed = 15;
  self.sprite.acceleration = 0.5;
  self.sprite.healthBar.maxHealth = 25;
  self.sprite.healthBar.health = 25;
  self.sprite.healthBar.armour = math.random(12, 17)

  self.chaseTimeout = 0;
  self.damageTimeout = 0;
  self.turnRateAngleDiff = 0;

  physics.addBody(self.sprite, "dynamic");
  self.sprite.gravityScale = 0;
end

function M.class:runCoroutine()

  local oldX = self.x;
  local oldY = self.y;

  if(self:getDistanceTo(player:getX(), player:getY()) < 15) then

  end

  if(self:getDistanceTo(player:getX(), player:getY()) < 1000) then
    self.chaseTimeout = 15;
  elseif(self.chaseTimeout > 0) then
    self.chaseTimeout = self.chaseTimeout - 1;
  end

  if (self.chaseTimeout > 0) then
    self.turnRateAngleDiff = (self.sprite.rotation - self:getDirectionTo(player:getX(), player:getY()) + 180) % 360 - 180;

    if (self.turnRateAngleDiff > 10) then
      self.sprite.rotation = self.sprite.rotation - 3;
    elseif (self.turnRateAngleDiff < -10) then
      self.sprite.rotation = self.sprite.rotation + 3;
    else
      self.sprite.rotation = self:getDirectionTo(player:getX(), player:getY());
    end

    self.x = self.x + (self.sprite.maxSpeed * math.sin(math.rad(self.sprite.rotation)));
    self.y = self.y + (self.sprite.maxSpeed * -math.cos(math.rad(self.sprite.rotation)));

    if(self:hasCollided(player:getDisplayObject())) then
      self.x = oldX;
      self.y = oldY;
      if(self.damageTimeout <= 0) then
        player:damage(2);
        self.damageTimeout = 20;
      end
    end
    self.damageTimeout = self.damageTimeout - 1;
  end

  --print(self.chaseTimeout);

end

return M;
