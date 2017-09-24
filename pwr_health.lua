--------------------------------------------------------------------------------
--
-- Powerup --> Health Kit; Heals player health;
--
--------------------------------------------------------------------------------
--------------------------------- PWR_HEALTH.LUA -------------------------------
--------------------------------------------------------------------------------
local basePowerup = require("powerup");
local class = require("classy");
local physics = require("physics");

local M = {};

M.class = class("Healthkit", basePowerup.class);

function M.class:__init(_index, params)
  params.image = "img/sprites/pwr-health.png";
  basePowerup.class.__init(self, params);
  self.index = _index;
  self.name = "Healthkit";
end

function M.class:sayHello()
  if(self.name) then print(self.name); end
end

function M.class.onCollision(self, event)
  if(event.phase == "began") then
    self.isDead = true;
    event.other.healthBar.health = event.other.healthBar.health + 300 + (self.width/5);
    if (event.other.healthBar.health > event.other.healthBar.maxHealth) then
      event.other.healthBar.health = event.other.healthBar.maxHealth;
    end
		local soundEffect = audio.loadSound( "audio/sfx/success.wav" )
		audio.play( soundEffect )
  end
end

return M;
