--------------------------------------------------------------------------------
--
-- Contains all logic for bullets and their interaction with other entities
--
-- bullets.lua
--
------------------------------- Private Fields ---------------------------------
local physics = require("physics");
local scene = require("scene")

local bullets = {};
local bullets_mt = {__index = bullets}; --metatable

local bulletNum;
local bullet = {};
local numberOfBulletsToRemove;
local baseObject;

--Constructor
function bullets.new(_object)
  local newBullets = {
  }

  baseObject = _object; --the object that the bullets originate from, e.g. the ship

  bulletNum = 0;
  bullet = {};
  numberOfBulletsToRemove = 0;

  return setmetatable(newBullets, bullets_mt);
end

------------------------------ Public Functions --------------------------------

function bullets:init()
  physics.start();
  physics.setGravity( 0, 0 );
end

function bullets:getTable()
  return bullet;
end

function bullets:getX(_index)
  if (table.getn(bullet) >= 1) then
    return bullet[_index].x;
  else
    return -99999
  end
end

function bullets:getY(_index)
  if (table.getn(bullet) >= 1) then
    return bullet[_index].y;
  else
    return -99999
  end
end

function bullets:shoot()
  bulletNum = table.getn(bullet);
  bullet[bulletNum] = display.newRect(baseObject.x, baseObject.y, baseObject.width/8, baseObject.height/3);
  bullet[bulletNum]:setFillColor(0.6, 0.8, 1);
  bullet[bulletNum].rotation = baseObject.rotation;
  scene:addObjectToScene(bullet[bulletNum], 1)

  physics.addBody(bullet[bulletNum], "kinematic");
  bullet[bulletNum]:setLinearVelocity(math.sin(math.rad(bullet[bulletNum].rotation))*50000, -math.cos(math.rad(bullet[bulletNum].rotation))*50000);
end

function bullets:removeBullets()
  numberOfBulletsToRemove = 0;
  for i = 1, table.getn(bullet) do
    if (bullet[i].x > (baseObject.x + 2000)
    or bullet[i].x < (baseObject.x - 2000)
    or bullet[i].y > (baseObject.y + 1000)
    or bullet[i].y < (baseObject.y - 1000)) then
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
