--Standard Modules
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local color = require("custom-widgets.color")
local dpi = beautiful.xresources.apply_dpi

local separator = wibox.widget.textbox(" ")

local ss_tool = require("custom-widgets.screenshot")

--Popup Menus
local control = require("custom-widgets.control_center")
-- local notif_center = require("popups.notif_center.main")
local media = require("custom-widgets.media_player")

local create_button = function(icon)
	--Imagebox for icon
	local icon_image = wibox.widget {
		widget = wibox.widget.imagebox,
		image = os.getenv("HOME") .. "/.config/awesome/assets/icons/" .. icon .. ".png",
		resize = true,
		opacity = 1,
	}

	--Main button
	local created_button = wibox.widget {
		screen = awful.screen.focused(),
		{
			icon_image,
			left   = dpi(5),
			right  = dpi(5),
			top    = dpi(5),
			bottom = dpi(5),
			widget = wibox.container.margin
		},
		bg = beautiful.bg_taglist,
		shape = gears.shape.rounded_rect,
		widget = wibox.container.background,
	}
	return created_button
end

local screenshot = create_button('screenshot')
local settings = create_button('settings')
local music = create_button('music-icon')

screenshot:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		ss_tool.visible = not ss_tool.visible
	elseif button == 3 then
		awful.spawn.with_shell(
			'scrot /tmp/screenshot.png && convert /tmp/screenshot.png -resize 20% /tmp/resized_screenshot.png && dunstify -i /tmp/resized_screenshot.png "Screenshot Captured" && cp /tmp/screenshot.png ~/Imágenes/screenshots/`date +"%Y%m%d_%H%M%S"`_scrot.png && rm /tmp/resized_screenshot.png && rm /tmp/screenshot.png'
		)
	end
end)

settings:connect_signal("button::release", function()
	control.visible = not control.visible
	-- notif_center.visible = false
	media.visible = false
end)

music:connect_signal("button::release", function()
	media.visible = not media.visible
	control.visible = false
end)

--Main Window
local grouped_buttons = wibox.widget {
	{
		{
			separator,
			music,
			separator,
			settings,
			separator,
			screenshot,
			separator,

			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.background,
		shape  = gears.shape.rounded_rect,
		bg     = beautiful.bg_taglist
	},
	left   = dpi(0),
	right  = dpi(0),
	top    = dpi(0),
	bottom = dpi(0),
	widget = wibox.container.margin

}

return grouped_buttons
