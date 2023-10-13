local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("custom-widgets.color")
local icon_path = os.getenv("HOME") .. "/.config/awesome/custom-widgets/control_dashlets/assets/"

--Powerbutton
local power = wibox.widget { {
  {
    image = icon_path .. "power3.png",
    widget = wibox.widget.imagebox,
    resize = true,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 20)
    end,

  },
  widget = wibox.container.margin,
  top = dpi(5),
  bottom = dpi(5),
  right = dpi(6),
  left = dpi(7),
  forced_height = dpi(20)
},
  widget = wibox.container.background,
  bg = color.background_lighter,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
  end,

}

--Hover highlight effects
power:connect_signal("mouse::enter", function()
  power.bg = "#343b58"
end)

power:connect_signal("mouse::leave", function()
  power.bg = color.background_lighter
end)

power:connect_signal("button::press", function()
  power.bg = color.background_morelight
end)

power:connect_signal("button::release", function()
  power.bg = "#343b58"
end)

power:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    awful.spawn("clearine")
    awesome.emit_signal("widget::control")
  end
end)


--Main Widget
local buttons = wibox.widget {
  {
    {
      power,
      layout = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.margin,
    top = dpi(6),
    bottom = dpi(6),
    right = dpi(6),
    left = dpi(6),
  },
  widget = wibox.container.background,
  bg = color.background_lighter,
  -- forced_height = 60,
  forced_width = dpi(40),
  halign = center,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
}

return buttons
