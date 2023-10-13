--Standard Modules
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("custom-widgets.color")
local dashboard = require("custom-widgets.dashboard")

--Main Logo
local main_button = wibox.widget {
	{
		{
			widget = wibox.widget.imagebox,
			image = beautiful.awesome_icon_launcher,
			resize = true,
			opacity = 1,
		},
		left   = dpi(0),
		right  = dpi(0),
		top    = dpi(0),
		bottom = dpi(0),
		widget = wibox.container.margin
	},
	bg = color.background_dark,
	-- shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
}

main_button:connect_signal("button::release", function()
	dashboard.visible = not dashboard.visible
end)

return main_button
