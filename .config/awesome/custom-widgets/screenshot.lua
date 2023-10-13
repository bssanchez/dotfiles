local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")

local color = require("custom-widgets.color")
local titlebar = require("custom-widgets.screenshot_dashlets.titlebar")

local ss_buttons = require('custom-widgets.screenshot_dashlets.buttons')
local timer_button = ss_buttons.timed
local fullscreen = ss_buttons.full
local selection = ss_buttons.selection

local Separator = wibox.widget.textbox("    ")
Separator.forced_height = 200
Separator.forced_width = 300

--Text Boxes
--Delay time
local delay_time = 3

local function timer_value(num)
	if (num > 0) then
		Value = num;
	else
		Value = 0;
	end
	return Value
end

local delay_text = wibox.widget {
	-- text = user.name,
	markup = '<span color="' ..
		color.white .. '" font="Fira Code Nerd Font 11">' .. "Delay in seconds" .. '</span>',
	font = "Fira Code Nerd Font Bold 14",
	widget = wibox.widget.textbox,
	fg = color.white
}

local timer = wibox.widget {
	markup = '<span color="' ..
		color.yellow .. '" font="Fira Code Nerd Font Bold 11">' .. "󱎫 " .. timer_value(delay_time) .. " " .. '</span>',
	font = "Fira Code Nerd Font Bold 14",
	widget = wibox.widget.textbox,
	fg = color.white

}

local increase_timer = wibox.widget {
	markup = '<span color="' ..
		color.green .. '" font="Fira Code Nerd Font Bold 11">' .. "    " .. '</span>',
	font = "Fira Code Nerd Font Bold 14",
	widget = wibox.widget.textbox,
	fg = color.white

}

increase_timer:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		delay_time = delay_time + 1
		timer:set_markup_silently('<span color="' ..
			color.blue .. '" font="Fira Code Nerd Font Bold 11">' .. "󱎫 " .. timer_value(delay_time) .. " " .. '</span>')
	end
end)

local decrease_timer = wibox.widget {
	markup = '<span color="' ..
		color.red .. '" font="Fira Code Nerd Font Bold 11">' .. "    " .. '</span>',
	font = "Fira Code Nerd Font Bold 14",
	widget = wibox.widget.textbox,
	fg = color.white

}

decrease_timer:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		if delay_time > 0 then
			delay_time = delay_time - 1
		else
			delay_time = delay_time
		end
		timer:set_markup_silently('<span color="' ..
			color.blue .. '" font="Fira Code Nerd Font Bold 11">' .. "󱎫 " .. timer_value(delay_time) .. " " .. '</span>')
	end
end)

local vertical_separator = wibox.widget {
	orientation = 'vertical',
	forced_height = dpi(1.5),
	forced_width = dpi(1.5),
	span_ratio = 0.75,
	widget = wibox.widget.separator,
	color = color.grey,
	border_color = color.grey,
	opacity = 0.75
}

local delay_control = wibox.widget {
	{
		{
			increase_timer,
			vertical_separator,
			decrease_timer,
			layout = wibox.layout.fixed.horizontal
		},
		widget = wibox.container.margin,
		left = dpi(4),
		right = dpi(4)
	},
	widget = wibox.container.background,
	bg = color.background_lighter2,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 5)
	end,
}

local delay = wibox.widget {
	{
		{
			delay_text,
			widget = wibox.container.margin,
			left = dpi(10),
			top = dpi(5),
			bottom = dpi(5),
			right = dpi(15),
		},
		{
			timer,
			widget = wibox.container.margin,
			left = dpi(5),
			top = dpi(12),
			bottom = dpi(12),
			right = dpi(0),
		},
		{
			delay_control,
			widget = wibox.container.margin,
			left = dpi(0),
			top = dpi(7),
			bottom = dpi(7),
			right = dpi(10),
		},
		layout = wibox.layout.fixed.horizontal,
		-- forced_width = dpi(400)
	},
	widget = wibox.container.background,
	bg = color.background_lighter,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 5)
	end,

}

--Toggle Mouse cursor-------------------------

local pointer_visible = true

local pointer_text = wibox.widget {
	-- text = user.name,
	markup = '<span color="' ..
		color.white .. '" font="Fira Code Nerd Font 11">' .. "Show mouse cursor" .. '</span>',
	font = "Fira Code Nerd Font Bold 14",
	widget = wibox.widget.textbox,
	fg = color.white
}

local toggle_button = wibox.widget {
	-- text = user.name,
	markup = '<span color="' ..
		color.blue .. '" font="Fira Code Nerd Font Bold 19">' .. "  " .. '</span>',
	font = "Fira Code Nerd Font Bold 14",
	widget = wibox.widget.textbox,
	fg = color.white
}

local toggle_cursor = wibox.widget {
	{
		{
			pointer_text,
			widget = wibox.container.margin,
			left = dpi(10),
			top = dpi(12),
			bottom = dpi(12),
			right = dpi(100),
		},
		{
			toggle_button,
			widget = wibox.container.margin,
			left = dpi(0),
			top = dpi(0),
			bottom = dpi(0),
			right = dpi(5),
		},
		layout = wibox.layout.fixed.horizontal,
		-- forced_width = dpi(400)
	},
	widget = wibox.container.background,
	bg = color.background_lighter,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 5)
	end,

}

toggle_button:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		pointer_visible = not pointer_visible
		if pointer_visible then
			toggle_button:set_markup_silently('<span color="' ..
				color.blue .. '" font="Fira Code Nerd Font Bold 19">' .. "  " .. '</span>')
		else
			toggle_button:set_markup_silently('<span color="' ..
				color.blue .. '" font="Fira Code Nerd Font Bold 19">' .. "  " .. '</span>')
		end
	end
end)



----------------------------------------------
--Main Popup----------------------------------
----------------------------------------------
local ss_tool = awful.popup {
	screen = awful.screen.focused(),
	widget = wibox.container.background,
	ontop = true,
	bg = "#00000000",
	visible = false,
	-- maximum_width = 200,
	placement = function(c)
		awful.placement.centered(c,
			{ margins = { top = dpi(0), bottom = dpi(0), left = dpi(0), right = dpi(0) } })
	end,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 0)
	end,
	opacity = 1,
	forced_height = dpi(330),
	forced_width = dpi(450),
	border_color = color.blue,
	border_width = dpi(2)
}

ss_tool:setup {
	titlebar,
	{
		{
			Separator,
			widget = wibox.container.background,
			bg = color.background_dark
		},
		{
			{
				{
					{
						fullscreen,
						widget = wibox.container.margin,
						left = dpi(5),
						right = dpi(5)
					},
					{
						selection,
						widget = wibox.container.margin,
						left = dpi(5),
						right = dpi(5)
					},
					{
						timer_button,
						widget = wibox.container.margin,
						left = dpi(5),
						right = dpi(5)
					},
					layout = wibox.layout.fixed.horizontal
				},
				widget = wibox.container.margin,
				top = dpi(10),
				bottom = dpi(10),
				left = dpi(5),
				right = dpi(5),
			},
			{
				delay,
				widget = wibox.container.margin,
				top = dpi(0),
				bottom = dpi(0),
				left = dpi(10),
				right = dpi(10)
			},
			{
				toggle_cursor,
				widget = wibox.container.margin,
				top = dpi(10),
				bottom = dpi(10),
				left = dpi(10),
				right = dpi(10)
			},

			layout = wibox.layout.fixed.vertical
		},
		layout = wibox.layout.stack
	},

	layout = wibox.layout.fixed.vertical
}

awesome.connect_signal("widget::screenshot", function()
	ss_tool.visible = false
end)

--Screenshot Functionalities
local ss_name = os.date("%Y%m%d_%H%M%S") .. '_scrot'

local open_pictures = naughty.action {
	name = 'Pictures',
	icon_only = false,
}

local delete_ss = naughty.action {
	name = 'Delete',
	icon_only = false,
}

local open_image = naughty.action {
	name = 'Open',
	icon_only = false,
}

open_pictures:connect_signal(
	'invoked',
	function()
		awful.spawn('pcmanfm ' .. 'Imágenes/screenshots', false)
	end
)

delete_ss:connect_signal(
	'invoked',
	function()
		awful.spawn.with_shell('rm ' .. 'Imágenes/screenshots/' .. ss_name .. '.png', false)
	end
)

open_image:connect_signal(
	'invoked',
	function()
		awful.spawn.with_shell('nomacs Imágenes/screenshots/' .. ss_name .. '.png --scale-down', false)
	end
)

fullscreen:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		ss_tool.visible = false
		awful.spawn.easy_async_with_shell('sleep 0.3 && scrot ~/Imágenes/screenshots/' .. ss_name .. '.png',
			function()
				naughty.notify
				(
					{
						title = '<span color="' ..
							color.white .. '" font="Fira Code Nerd Font Bold 10">  Screenshot Tool</span>',
						text = '<span color="' .. color.white .. '"> Screenshot Captured!</span>',
						timeout = 5,
						icon = os.getenv("HOME") .. "/Imágenes/screenshots/" .. ss_name .. ".png",
						actions = { open_image, open_pictures, delete_ss }
					}
				)
			end)
	end
end)

timer_button:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		ss_tool.visible = false
		awful.spawn.easy_async_with_shell('sleep 0.3 && scrot -d ' .. delay_time .. ' ~/Imágenes/screenshots/' .. ss_name .. '.png',
			function()
				naughty.notify
				(
					{
						title = '<span color="' ..
							color.white .. '" font="Fira Code Nerd Font Bold 10">  Screenshot Tool</span>',
						text = '<span color="' .. color.white .. '"> Screenshot Captured!</span>',

						timeout = 5,
						icon = os.getenv("HOME") .. "/Imágenes/screenshots/" .. ss_name .. ".png",
						actions = { open_image, open_pictures, delete_ss }
					}
				)
			end)
	end
end)

selection:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		ss_tool.visible = false
		awful.spawn.easy_async_with_shell('sleep 0.3 && scrot -s ' .. '~/Imágenes/screenshots/' .. ss_name .. '.png',
			function()
				naughty.notify
				(
					{
						title = '<span color="' ..
							color.white .. '" font="Fira Code Nerd Font Bold 10">  Screenshot Tool</span>',
						text = '<span color="' .. color.white .. '"> Screenshot Captured!</span>',
						-- title = '<span font="Fira Code Nerd Font Bold 14">  Screenshot Tool</span>',
						-- text = "Screen Captured!",
						timeout = 5,
						icon = os.getenv("HOME") .. "/Imágenes/screenshots/" .. ss_name .. ".png",
						actions = { open_image, open_pictures, delete_ss }
					}
				)
			end)
	end
end)


return ss_tool
