--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("custom-widgets.color")
local user = require("custom-widgets.user_profile")

--Header text
local textbox = wibox.widget {
  markup = '<span color="' .. color.red .. '" font="Fira Code Nerd Font bold 12">' .. "   おっす, " .. user.name .. '!' .. '</span>',
  font = "Fira Code Nerd Font 10",
  widget = wibox.widget.textbox,
  fg = color.white
}

--Main widget
local header = wibox.widget {
  {
    {
      textbox,
      widget = wibox.container.margin,
      top = dpi(7),
      bottom = dpi(5),
      right = dpi(5),
      left = dpi(8),
    },
    widget = wibox.container.background,
    bg = color.background_lighter,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 7)
    end,
  },
  widget = wibox.container.margin,
  top = dpi(14),
  left = dpi(12),
  right = dpi(12),
  forced_height = dpi(50),
}

return header
