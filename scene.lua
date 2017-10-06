--------------------------------------------------------------------------------
--
-- Used to add objects to the game scene,
-- As well as camera tracking and parallax movement
--
-- scene.lua
------------------------------- Private Fields ---------------------------------
local perspective = require("perspective");

local scene = {};
local scene_mt = {__index = scene}; --metatable

local camera;
local sceneNum;
local bgm;
local sceneStars = {};

------------------------------ Public Functions --------------------------------
function scene:addObjectToScene(_obj, _layer)
  camera:add(_obj, _layer);
end

function scene:addFocusTrack(_obj)
  camera:setFocus(_obj);
  camera:track();
end

function scene:init(_sceneNum)
  sceneNum = _sceneNum;
  camera = perspective.createView();
  camera:prependLayer();

  if(_sceneNum == 1) then
    ----------------------------------------------------------------------------
    -- Adds in Scenery
    ----------------------------------------------------------------------------
    --local sceneStars = {};
    for i = 1, 1400 do
      if (math.random(1, 4) == 1) then
        sceneStars[i] = display.newRect(0, 0, 10, 10);
        sceneStars[i].rotation = 45;
      else
        sceneStars[i] = display.newCircle(0, 0, 10);
      end
      sceneStars[i].x = math.random(-10 * display.contentWidth, 10 * display.contentWidth);
      sceneStars[i].y = math.random(-10 * display.contentHeight, 10 * display.contentHeight);
      sceneStars[i]:setFillColor(math.random(100) * 0.01, math.random(100) * 0.01, math.random(100) * 0.01);
      sceneStars[i].layer = math.random(2, camera:layerCount());
      camera:add(sceneStars[i], sceneStars[i].layer);
      sceneStars[i].width = (11 - sceneStars[i].layer) * 3;
      sceneStars[i].height = (11 - sceneStars[i].layer) * 3;
    end

    --adds paralax to the layers
    camera:setParallax(1, 1, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2); -- Here we set parallax for each layer in descending order

    camera.damping = 5;

		--loads music
		bgm = audio.loadStream("audio/music/track1.wav");
  end
	--plays music
	audio.reserveChannels(1);
	audio.setVolume( 0.8, { channel=1 } );
	--audio.play( bgm, { channel=1, loops=-1 } )
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

function scene:run(_focalX, _focalY)
  _focalX = _focalX or 0;
  _focalY = _focalY or 0;
  wBound = display.contentWidth;
  hBound = display.contentHeight;
  for i = 1, #sceneStars do
    local star = sceneStars[i]
    local layer = math.random(2, camera:layerCount());

    --print (_focalX .. "|||" .. wBound)

    if math.abs(star.x - _focalX) > 2.5 * star.layer * wBound
    or math.abs(star.y - _focalY) > 2.5 * star.layer * hBound then
      if (star.x - _focalX < -2.5 * star.layer * wBound) then
        star.x = star.x + 3 * star.layer * wBound
      elseif (star.x - _focalX > 2.5 * star.layer * wBound) then
        star.x = star.x - 3 * star.layer * wBound
      end

      if (star.y - _focalY < -2.5 * star.layer * hBound) then
        star.y = star.y + 3 * star.layer * hBound
      elseif (star.y - _focalY > 2.5 * star.layer * hBound) then
        star.y = star.y - 3 * star.layer * hBound
      end
      -- star.x = math.random(_focalX - 2 * wBound, _focalX + 2 * wBound);
      -- star.y = math.random(_focalY - 2 * hBound, _focalY + 2 * hBound);

      --camera:add(star, layer)
    end
  end
end

return scene;
