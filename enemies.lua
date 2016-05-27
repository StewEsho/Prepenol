--------------------------------------------------------------------------------
--
-- Centralized module for spawning, tracking, and handling enemies
-- Contains a table, which itself contains more table_insert
-- Each subtable contains all instances of enemies.
-- This way, every enemy can be accessed through this one module
--
-- enemies.lua
--
------------------------------- Private Fields ---------------------------------
local scene = require("scene");

local skeleton = require("en_skeleton");
local aquae = require("en_aqua");
local fireballer = require("en_fire");
local turret = require("en_turret");

enemies = {};
enemies_mt = {__index = enemies}; --metatable

local enemyList;
local moduleList;
local skeletonList;
local aquaeList;
local fireList;
local turretList;

local enemyCount = 0; --stores number of enemies spawned
local enemyTimer = 0; --used to repeatedly spawn in enemies

--------------------------------- Constructor ----------------------------------

function enemies.new()
  local newEnemies = {
  }
  setmetatable(newEnemies, enemies_mt);

  skeletonList = {}; --List of all Skeleton enemies
  aquaeList = {}; --List of all aquae ships
  fireList = {}; --List of all fireballer ships
  turretList = {};
  --List of all enemies
  enemyList = {
    --[[
    /////INDEX of ENEMIES/////

    [1] = skeletonList
    [2] = aquaList
    [3] = fireList
    [4] = turretList

    ]]
    skeletonList,
    aquaeList,
    fireList,
    turretList
  }

  --List of all clases; corresponds with order in enemyList
  --Used to spawn instances of these classes
  moduleList = {
    skeleton,
    aquae,
    fireballer,
    turret
  }

  return newEnemies;
end

------------------------------ Public Functions --------------------------------

--[[
  spawn(_index, _layer, _x, _y)
    - spawns a new enemy, and adds it to the list
    - _index determines which type of enemy to spawn
    - does NOT add the oobject to the scene
    @return the instance of the enemy;

  get(_index1, _index2)
    - retrieves the specificed enemy instance;
    - _index1 is the type of enemy, and _index2 specifes which in particular
    - retrieves newest instance if _index2 is not specified
    @return the instance of the enemy;
]]

function enemies:spawn(_index, _x, _y, params)
  params = params or {};
  if (_index and _index ~= 4) then
    table.insert(enemyList[_index], moduleList[_index].class(_x, _y, table.getn(enemyList[_index])+1, params));
    --print(enemyList[_index][table.getn(enemyList[_index])].sprite.name .. " | " .. enemyList[_index][table.getn(enemyList[_index])].sprite.index);
    return enemyList[_index][table.getn(enemyList[_index])];
  else
    return -1;
  end
end

function enemies:get(_index1, _index2)
  if (_index1 == nil) then
    return enemyList;
  elseif (_index2 == nil) then
    return enemyList[_index1];
  else
    return enemyList[_index1][_index2];
  end
end

function enemies:kill(_index1, _index2)
  table.remove(enemyList[_index1], _index2);
end

function enemies:randomSpawn(_x, _y, params)
  --randomly spawns enemies
  if (enemyTimer < 120) then
    enemyTimer = enemyTimer + 1;
  else
    enemyTimer = 0;
    if (enemyCount < 25) then
      enemies:spawn(math.random(1, table.getn(enemyList)), math.random(_x - 3000, _x + 3000), math.random(_y - 3000, _y + 3000), params);
    end
  end
end

function enemies:run(params)
  enemyCount = 0;
  --runs logic behind enemies
  for i = 1, table.getn(enemyList) do
    for j = 1, table.getn(enemyList[i]) do
      if (enemyList[i][j] == nil) then break
      elseif (enemyList[i][j].sprite.isDead == true) then
        enemyList[i][j]:kill();
        table.remove(enemyList[i], j);
      else
        enemyList[i][j]:run(params.radar);
        enemyList[i][j]:runCoroutine();
        enemyCount = enemyCount + 1;
      end
    end
  end
  return enemyCount;
end

return enemies;
