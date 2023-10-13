--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("custom-widgets.color")

--Widgets
local header = require("custom-widgets.dashlets.header")
local profile = require("custom-widgets.dashlets.profile")
local calendar = require("custom-widgets.dashlets.calendar")
local weather = require("custom-widgets.dashlets.weather")
local launch = require("custom-widgets.dashlets.quick_launch")
-- local exit = require("custom-widgets.dashlets.exit")

--Separator/Background
local Separator = wibox.widget.textbox("    ")
Separator.forced_height = 720
Separator.forced_width = 350

--Sidebar
local sidebar = require("custom-widgets.dashlets.sidebar")

--Main Wibox
local dashboard_home = awful.popup {
	screen = awful.screen.focused(),
	widget = wibox.container.background,
	ontop = true,
	bg = "#00000000",
	visible = false,
	forced_width = 350,
	maximum_height = 720,
	placement = function(c)
		awful.placement.top_left(c,
			{ margins = { top = dpi(30), bottom = dpi(8), left = dpi(8), right = dpi(8) } })
	end,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 0)
	end,
	opacity = 1
}

local home = wibox.widget {
	header,
	profile,
	calendar,
	weather,
	launch,
	-- exit,
	layout = wibox.layout.fixed.vertical,
}

dashboard_home:setup {
	{
		{
			home,
			Separator,
			layout = wibox.layout.stack
		},
		sidebar,
		layout = wibox.layout.fixed.horizontal
	},
	widget = wibox.container.background,
	bg = color.background_dark,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
}


return dashboard_home
