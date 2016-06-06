--------------------------------------------------------------------------------
--
--  Functionality for adding buttons, used in game and in menus
--
--  button.lua
--
------------------------------- Private Fields ---------------------------------
local class = require ("classy");

local button = {};
button.newInstance = class("Button");

--[[
_x,
_y,
_width,
_height,
_toggleable,
_r,
_g,
_b,
_a,
_tag
]]

--Constructor
function button.newInstance:__init(params)

  self.x = params.x;
  self.y = params.y;
  self.width = params.width;
  self.height = params.height;

  self.buttonBox = display.newRect(self.x, self.y, self.width, self.height);

  self.buttonBox.tag = params.tag or "button";
  self.buttonBox.isToggleable = params.isToggleable or false;
  self.buttonBox.isPressed = false;
  self.buttonBox.r = params.r or 1;
  self.buttonBox.g = params.g or 1;
  self.buttonBox.b = params.b or 1;
  self.buttonBox.a = params.a or 1;

  self.buttonBox.originalWidth = params.width;
  self.buttonBox.originalHeight = params.height;
  self.buttonBox.originalX = params.x;
  self.buttonBox.originalY = params.y;
  self.buttonBox:setFillColor(self.buttonBox.r, self.buttonBox.g, self.buttonBox.b, self.buttonBox.a);

  --initializes the touch input
  self.buttonBox.touch = self.run;
  self.buttonBox:addEventListener("touch", self.buttonBox);
end
------------------------------ Public Functions --------------------------------

function button.newInstance:run(event)
  if (event.phase == "began") then
    if(event.target.isToggleable == false) then
      event.target.width = event.target.originalWidth - 50;
      event.target.height = event.target.originalHeight - 50;
      event.target.isPressed = true;
    else
      event.target.isPressed = not event.target.isPressed;
      if (event.target.isPressed) then
        event.target.width = event.target.originalWidth - 50;
        event.target.height = event.target.originalHeight - 50;
      else
        event.target.width = event.target.originalWidth;
        event.target.height = event.target.originalHeight;
      end
    end
  elseif(event.phase == "ended" or event.phase == "cancelled") then
    if(event.target.isToggleable == false) then
      event.target.width = event.target.originalWidth;
      event.target.height = event.target.originalHeight;
      event.target.isPressed = false;
    end
  end
end

function button.newInstance:getDisplayObject()
  return self.buttonBox;
end

function button.newInstance:isPressed()
  return self.buttonBox.isPressed;
end

function button.newInstance:setCoordinates(_x, _y)
  self.buttonBox.x = _x;
  self.buttonBox.y = _y;
end

return button;
