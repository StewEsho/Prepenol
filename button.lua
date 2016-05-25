--------------------------------------------------------------------------------
--
--  Functionality for adding buttons, used in game and in menus
--
--  button.lua
--
------------------------------- Private Fields ---------------------------------

local button = {};
local button_mt = {__index = button}; --metatable

local r, g, b, a;
local width, height;
local x, y;
local isPressed;
local isToggleable;
local tag;

local buttonBox;

--Constructor
function button.new(_x,
                    _y,
                    _width,
                    _height,
                    _toggleable,
                    _r,
                    _g,
                    _b,
                    _a,
                    _tag)
  local newButton = {
    x = _x;
    y = _y;
    width = _width;
    height = _height;
    tag = _tag;
    isToggleable = _toggleable
  }

  x = _x;
  y = _y;
  width = _width;
  height = _height;
  tag = _tag or "button";
  isToggleable = _toggleable or false;
  isPressed = false;
  r = _r or 1;
  g = _g or 1;
  b = _b or 1;
  a = _a or 1;

  buttonBox = display.newRect(x, y, width, height);
  buttonBox.anchorX = 1;
  buttonBox.anchorY = 1;

  buttonBox:setFillColor(r, g, b, a);

  return setmetatable(newButton, button_mt);
end
----------------------------- Private Functions --------------------------------

local function run(event)
  if(event.phase == "began") then
    if(isToggleable == false) then
      buttonBox.width = width - 50;
      buttonBox.height = height - 50;
      buttonBox.x = display.contentWidth - 25;
      buttonBox.y = display.contentHeight - 25;
      isPressed = true;
    else
      isPressed = not isPressed;
      if (isPressed) then
        buttonBox.width = width - 50;
        buttonBox.height = height - 50;
        buttonBox.x = display.contentWidth - 25;
        buttonBox.y = display.contentHeight - 25;
      else
        buttonBox.width = width;
        buttonBox.height = height;
        buttonBox.x = display.contentWidth;
        buttonBox.y = display.contentHeight;
      end
    end
  elseif(event.phase == "ended" or event.phase == "cancelled") then
    if(isToggleable == false) then
      buttonBox.width = width;
      buttonBox.height = height;
      buttonBox.x = display.contentWidth;
      buttonBox.y = display.contentHeight;
      isPressed = false;
    end
  end
end

------------------------------ Public Functions --------------------------------

function button:init()
  buttonBox:addEventListener("touch", run);
end

function button:getDisplayObject()
  return buttonBox;
end

function button:isPressed()
  return isPressed;
end

function button:setCoordinates(_x, _y)
  x = _x;
  y = _y;
end

return button;
