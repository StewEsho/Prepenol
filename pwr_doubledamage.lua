--------------------------------------------------------------------------------
--
-- Powerup --> Double Damage; Doubles the player's bullet damage;
--
--------------------------------------------------------------------------------
----------------------------- pwr_doubledamage.lua -----------------------------
--------------------------------------------------------------------------------
local basePowerup = require("powerup");
local class = require("classy");
local physics = require("physics");
local timeMan = require("powerupTimerManager");

local M = {};

M.class = class("DoubleDam", basePowerup.class);

function M.class:__init(_index, params)
  params.image = "img/sprites/pwr-doubleD.png";
  basePowerup.class.__init(self, params);
  self.index = _index;
  self.name = "Double Damage";
  self.sprite.duration = 7;
end

function M.class:sayHello()
  if(self.name) then print(self.name); end
end

function M.class.onCollision(self, event)
  if(event.phase == "began") then
    self.isDead = true;
    event.other.powerupBuffs[2] = self.duration*60; --buff duration
    timeMan:create(2, {r = 0.2, g = 0.1, b = 0.8, x = 800, duration = self.duration});
    event.other:setFillColor(90/255, 30/255, 255/255)
    event.other.bulletDamage = event.other.bulletDamage * 2;
  end
end

return M;
