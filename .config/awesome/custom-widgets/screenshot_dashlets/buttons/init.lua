local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("custom-widgets.color")

local function create_button(img, hover_img)
	--Image widget
	local image = wibox.widget {
		widget = wibox.widget.imagebox,
		image = os.getenv("HOME") .. "/.config/awesome/assets/icons/" .. img .. ".png",
		resize = true,
		opacity = 1,
	}

	local button = wibox.widget {
		{
			{
				{
					image,
					layout = wibox.layout.fixed.vertical
				},
				left   = dpi(10),
				right  = dpi(10),
				top    = dpi(10),
				bottom = dpi(10),
				widget = wibox.container.margin
			},
			layout = wibox.container.place
		},
		bg = color.background_lighter,
		shape = gears.shape.rounded_rect,
		widget = wibox.container.background,
		forced_height = dpi(90),
		forced_width = dpi(100),
	}

	button:connect_signal("mouse::enter", function()
		button.bg = color.blueish_white
		image.image = os.getenv("HOME") .. "/.config/awesome/assets/icons/" .. hover_img .. ".png"
	end)

	button:connect_signal("mouse::leave", function()
		image.image = os.getenv("HOME") .. "/.config/awesome/assets/icons/" .. img .. ".png"
		button.bg = color.background_lighter
	end)

	button:connect_signal("button::press", function()
		button.bg = color.blue
	end)

	button:connect_signal("button::release", function()
		button.bg = color.blueish_white
	end)

	return button
end


local ss_buttons = {
	full = create_button('full', 'full-hover'),
	selection = create_button('selection', 'selection-hover'),
	timed = create_button('clock', 'clock-hover')
}

return ss_buttons
