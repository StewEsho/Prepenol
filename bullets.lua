--------------------------------------------------------------------------------
--
-- Contains all logic for bullets and their interaction with other entities
--
-- bullets.lua
--
------------------------------- Private Fields ---------------------------------
local physics = require("physics");
local ship = require("ship");

local bullets = {};
local bullets_mt = {__index = bullets}; --metatable

local bulletNum;
local bullet = {};
local numberOfBulletsToRemove;

--Constructor
function bullets.new(_x, _y, _acceleration)
  local newBullets = {
  }

  bulletNum = 0;
  bullets = {};
  numberOfBulletsToRemove = 0;

  return setmetatable(newBullets, bullets_mt);
end

------------------------------ Public Functions --------------------------------

function bullets:getTable()
  return bullet;
end

function bullets:shoot()
  bulletNum = table.getn(bullets) + 1;
  bullet[bulletNum] = display.newRect(player.x, player.y, width/12, length/3);
  bullet[bulletNum]:setFillColor(0.3, 0.6, 0.9);
  bullet[bulletNum].rotation = player.rotation;
  scene:addObjectToScene(bullet[bulletNum], 2)

  physics.addBody( bullet[bulletNum], "kinematic");
  bullet[bulletNum]:setLinearVelocity(math.sin(math.rad(bullet[bulletNum].rotation))*50000, -math.cos(math.rad(bullet[bulletNum].rotation))*50000);
  shootCooldown = 0;

end

function bullets:removeBullets()
  numberOfBulletsToRemove = 0;
  for i = 1, table.getn(bullet) do
    if (bullet[i].x > (player.x + 2000) or bullet[i].x < (player.x - 2000) or bullet[i].y > (player.y + 1000) or bullet[i].y < (player.y - 1000)) then
      numberOfBulletsToRemove = numberOfBulletsToRemove + 1;
    end
  end

  if numberOfBulletsToRemove > 0 then
    for j = 1, numberOfBulletsToRemove do
      bullet[j]:removeSelf();
      table.remove(bullet, j);
    end
  end
end

return bullets;
