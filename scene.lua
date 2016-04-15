--------------------------------------------------------------------------------
--
-- Used to add objects to the game scene,
-- As well as camera tracking and parallax movement
--
-- scene.lua
------------------------------- Private Fields ---------------------------------
local perspective = require("perspective")

local scene = {};
local scene_mt = {__index = scene}; --metatable

local camera;
local sceneNum;

------------------------------ Public Functions --------------------------------


function scene.new()
  local newScene = {
  }
  return setmetatable(newScene, scene_mt);
end

function scene:addObjectToScene(_obj, _layer)
  camera:add(_obj, _layer);
end

function scene:addFocusTrack(_obj)
  camera:setFocus(_obj);
  camera:track();
end

function scene:init(_sceneNum)
  camera = perspective.createView();
  camera:prependLayer();

  if(_sceneNum == 1) then
    ----------------------------------------------------------------------------
    -- Adds in Scenery
    ----------------------------------------------------------------------------
    local scene = {};
    for i = 1, 5000 do
      scene[i] = display.newCircle(0, 0, 10);
      scene[i].x = math.random(-display.contentWidth * 3, display.contentWidth * 3);
      scene[i].y = math.random(-display.contentHeight * 3, display.contentHeight * 3);
      scene[i]:setFillColor(math.random(100) * 0.01, math.random(100) * 0.01, math.random(100) * 0.01);
      local layer = math.random(0, camera:layerCount());
      camera:add(scene[i], layer);
      scene[i].width = (11 - layer) * 3;
      scene[i].height = (11 - layer) * 3;
    end

    --adds paralax to the layers
    camera:setParallax(1, 1, 1, 0.6, 0.5, 0.4, 0.3, 0.2); -- Here we set parallax for each layer in descending order

    camera.damping = 5;
  end
end

function scene:destruct(_sceneNum, _transition)
  _transition = _transition or "none";
  --todo
end

function scene:change(_firstScene, _secondScene, _transition)
  _transition = _transition or "none";

  scene:destruct(_firstScene, _transition);
  scene:init(_secondScene);
end

return scene;
