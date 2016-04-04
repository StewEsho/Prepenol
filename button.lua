--------------------------------------------------------------------------------
--
--  Functionality for adding buttons, used in game and in menus
--
--  button.lua
--
------------------------------- Private Fields ---------------------------------

local button = {};
local button_mt = {}; --metatable

local r, g, b;
local width, height;
local x, y;
local isPressed;
local isToggleable;
local tag;

local buttonBox;

--Constructor
function button.new(_x, _y, _width, _height, _toggleable, _r, _g, _b , _tag)
  local newButton = {
    x = _x;
    y = _y;
    width = _width;
    height = _height;
    tag = _tag;
    color = {_r/255, _g/255, _b/255};
    isToggleable = _toggleable
  }

  x = _x;
  y = _y;
  width = _width;
  height = _height;
  tag = _tag;
  isToggleable = _toggleable;
  isPressed = false;
  r = _r/255;
  g = _g/255;
  b = _b/255;

  buttonBox = display.newRect(x, y, width, height);
  buttonBox:setFillColor(r, g, b);
end
----------------------------- Private Functions --------------------------------

local function run(event)
  if(event.phase == "began") then
    if(isToggleable == false) then
      isPressed = true;
    else
      isPressed = not isPressed;
    end
  elseif(event.phase == "ended" or event.phase == "cancelled") then
    if(isToggleable == false) then
      isPressed = false;
    end
  end
end

------------------------------ Public Functions --------------------------------

function button:init()
  buttonBox:addEventListener("touch", run);
end

function button:isPressed()
  return isPressed;
end

function button:setCoordinates(_x, _y)
  x = _x;
  y = _y;
end

return button;
