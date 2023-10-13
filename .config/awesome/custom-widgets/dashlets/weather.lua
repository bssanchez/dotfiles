local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("custom-widgets.color")
local user = require("custom-widgets.user_profile")
local iconpath = os.getenv("HOME") .. '/.config/awesome/custom-widgets/dashlets/weather_icons/'
---------------------------------
--Base textboxes-----------------
---------------------------------

------------------------------
--Location & weather----------
------------------------------
local city_text = wibox.widget {
	markup = '<span color="' ..
		color.blue .. '" font="Fira Code Nerd Font 10">' .. " Earth (probably)" .. '</span>',
	font = "Fira Code Nerd Font 14",
	widget = wibox.widget.textbox,
	fg = color.white,
	forced_height = dpi(15),
}

local country_text = wibox.widget {
	markup = '<span color="' ..
		color.blue .. '" font="Fira Code Nerd Font 10">' .. ", SS" .. '</span>',
	font = "Fira Code Nerd Font 14",
	widget = wibox.widget.textbox,
	fg = color.white,
	forced_height = dpi(15),
}

local weather_text = wibox.widget {
	markup = '<span color="' ..
		color.white .. '" font="Fira Code Nerd Font 10">' .. "Loading... " .. '</span>',
	font = "Fira Code Nerd Font 14",
	widget = wibox.widget.textbox,
	fg = color.white,
	forced_height = dpi(15),
}

----------------------------
--temparature_text----------
----------------------------
local temparature_text = wibox.widget {
	markup = '<span color="' ..
		color.red .. '" font="Fira Code Nerd Font bold 24">' .. " " .. '°C' .. '</span>',
	font = "Fira Code Nerd Font 14",
	widget = wibox.widget.textbox,
	align = 'center',
	fg = color.white
}

----------------------------
--Third row-----------------
----------------------------
local humidity_text = wibox.widget {
	markup = '<span color="' ..
		color.white .. '" font="Fira Code Nerd Font 10">' .. "N/A" .. '</span>',
	font = "Fira Code Nerd Font 14",
	widget = wibox.widget.textbox,
	fg = color.white
}

local humidity_icon = wibox.widget {
	markup = '<span color="' ..
		color.magenta .. '" font="Fira Code Nerd Font bold 16">' .. "󱪅 " .. '</span>',
	font = "Fira Code Nerd Font 14",
	widget = wibox.widget.textbox,
	fg = color.white
}


local wind_text = wibox.widget {
	markup = '<span color="' ..
		color.blueish_white .. '" font="Fira Code Nerd Font 10">' .. "N/A" .. '</span>',
	font = "Fira Code Nerd Font 14",
	widget = wibox.widget.textbox,
	fg = color.white
}

local wind_icon = wibox.widget {
	markup = '<span color="' ..
		color.green .. '" font="Fira Code Nerd Font bold 16">' .. " " .. '</span>',
	font = "Fira Code Nerd Font 14",
	widget = wibox.widget.textbox,
	fg = color.white
}

local feels_like_text = wibox.widget {
	markup = '<span color="' ..
		color.white .. '" font="Fira Code Nerd Font 10">' .. "N/A" .. '</span>',
	font = "Fira Code Nerd Font 14",
	widget = wibox.widget.textbox,
	fg = color.white
}

local feels_like_icon = wibox.widget {
	markup = '<span color="' ..
		color.yellow .. '" font="Fira Code Nerd Font bold 16">' .. "󱤋 " .. '</span>',
	font = "Fira Code Nerd Font 14",
	widget = wibox.widget.textbox,
	fg = color.white
}
-----------------------
--Bottom Widget--------
-----------------------
local humidity = {
	{
		{
			humidity_icon,
			nil,
			humidity_text,
			layout = wibox.layout.align.horizontal
		},
		widget = wibox.container.margin,
		-- margins = dpi(9),
		top = dpi(5),
		bottom = dpi(5),
		right = dpi(6),
		left = dpi(10)
	},
	widget = wibox.container.background,
	bg = color.background_lighter2,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 20)
	end,
	forced_width = dpi(79),
}

local temp_feels_like = {
	{
		{
			feels_like_icon,
			nil,
			feels_like_text,
			layout = wibox.layout.align.horizontal
		},
		widget = wibox.container.margin,
		-- margins = dpi(9),
		top = dpi(5),
		bottom = dpi(5),
		right = dpi(6),
		left = dpi(6)
	},
	widget = wibox.container.background,
	bg = color.background_lighter2,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 20)
	end,
	forced_width = dpi(104),
}

local wind = {
	{
		{
			wind_icon,
			nil,
			wind_text,
			layout = wibox.layout.align.horizontal
		},
		widget = wibox.container.margin,
		-- margins = dpi(9),
		top = dpi(5),
		bottom = dpi(5),
		right = dpi(10),
		left = dpi(6)
	},
	widget = wibox.container.background,
	bg = color.background_lighter2,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 20)
	end,
	forced_width = dpi(116),
}

--------------------------------
--Image Icon--------------------
--------------------------------
local weath_image = wibox.widget {
	image = iconpath .. 'weather-error.svg',
	widget = wibox.widget.imagebox,
	resize = true,
	forced_height = dpi(60),
	forced_width = dpi(60)
}

----------------------------
--Setting values-----------
----------------------------

local weather_script = "bash ~/.local/bin/weather"
local get_icon = weather_script .. " | awk '{print $1}'"
local get_weather = weather_script .. " | awk '" .. '{print $8" "$9}' .. "'"
local get_temp = weather_script .. " | awk '{print $3}'"
local get_city = weather_script .. " | awk '{print $4}'"
local get_country = weather_script .. " | awk '{print $5}'"
local get_humidity = weather_script .. " | awk '{print $6}'"
local get_wind = weather_script .. " | awk '{print $7}'"
local get_feelslike = weather_script .. " | awk '{print $2}'"

awful.spawn.easy_async_with_shell(get_city, function(out)
	local str = string.gsub(out, "%s+", "")

	city_text.markup = '<span color="' ..
		color.blue .. '" font="Fira Code Nerd Font 10">' .. str .. '</span>'
end)

awful.spawn.easy_async_with_shell(get_country, function(out)
	local str = string.gsub(out, "%s+", "")

	country_text.markup = '<span color="' ..
		color.blue .. '" font="Fira Code Nerd Font 10">' .. ", " .. str .. '</span>'
end)

awful.spawn.easy_async_with_shell(get_weather, function(str)
	weather_text.markup = '<span color="' ..
		color.white .. '" font="Fira Code Nerd Font 10">' .. str .. "   " .. '</span>'
end)

awful.spawn.easy_async_with_shell(get_temp, function(out)
	local str = string.gsub(out, "%s+", "")
	temparature_text.markup = '<span color="' ..
		color.red .. '" font="Fira Code Nerd Font bold 24">' .. str .. '°C' .. '</span>'
end)

awful.spawn.easy_async_with_shell(get_humidity, function(out)
	local str = string.gsub(out, "%s+", "")
	humidity_text.markup = '<span color="' ..
		color.white .. '" font="Fira Code Nerd Font 10">' .. str .. " " .. '</span>'
end)

awful.spawn.easy_async_with_shell(get_feelslike, function(out)
	local str = string.gsub(out, "%s+", "")
	feels_like_text.markup = '<span color="' ..
		color.white .. '" font="Fira Code Nerd Font 10">' .. str .. "°C" .. '</span>'
end)

awful.spawn.easy_async_with_shell(get_wind, function(out)
	local str = string.gsub(out, "%s+", "")
	wind_text.markup = '<span color="' ..
		color.white .. '" font="Fira Code Nerd Font 10">' .. str .. " km/h" .. '</span>'
end)

awful.spawn.easy_async_with_shell(get_icon, function(out)
	local str = string.gsub(out, "%s+", "")
	local weather_image = iconpath .. 'd_rain.svg'

	if str == '50d' then
		weather_image = iconpath .. 'dmist.svg'
	elseif str == '01d' then
		weather_image = iconpath .. 'sun_icon.svg'
	elseif str == '01n' then
		weather_image = iconpath .. 'moon_icon.svg'
	elseif str == '02d' then
		weather_image = iconpath .. 'dfew_clouds.svg'
	elseif str == '02n' then
		weather_image = iconpath .. 'nfew_clouds.svg'
	elseif str == '03d' then
		weather_image = iconpath .. 'dscattered_clouds.svg'
	elseif str == '03n' then
		weather_image = iconpath .. 'nscattered_clouds.svg'
	elseif str == '04d' then
		weather_image = iconpath .. 'dbroken_clouds.svg'
	elseif str == '04n' then
		weather_image = iconpath .. 'nbroken_clouds.svg'
	elseif str == '09d' then
		weather_image = iconpath .. 'dshower_rain.svg'
	elseif str == '09n' then
		weather_image = iconpath .. 'nshower_rain.svg'
	elseif str == '010d' then
		weather_image = iconpath .. 'd_rain.svg'
	elseif str == '010n' then
		weather_image = iconpath .. 'n_rain.svg'
	elseif str == '011d' then
		weather_image = iconpath .. 'dthunderstorm.svg'
	elseif str == '011n' then
		weather_image = iconpath .. 'nthunderstorm.svg'
	elseif str == '013d' then
		weather_image = iconpath .. 'snow.svg'
	elseif str == '013n' then
		weather_image = iconpath .. 'snow.svg'
	elseif str == '50n' then
		weather_image = iconpath .. 'nmist.svg'
	elseif str == '...' then
		weather_image = iconpath .. 'weather-error.svg'
	end

	weath_image.image = weather_image
end)

--Update weather data each hour

local update_timer = function()
	awful.spawn.easy_async_with_shell(get_city, function(out)
		local str = string.gsub(out, "%s+", "")

		city_text.markup = '<span color="' ..
			color.blue .. '" font="Fira Code Nerd Font 10">' .. str .. '</span>'
	end)

	awful.spawn.easy_async_with_shell(get_country, function(out)
		local str = string.gsub(out, "%s+", "")

		country_text.markup = '<span color="' ..
			color.blue .. '" font="Fira Code Nerd Font 10">' .. ", " .. str .. '</span>'
	end)

	awful.spawn.easy_async_with_shell(get_weather, function(str)
		weather_text.markup = '<span color="' ..
			color.white .. '" font="Fira Code Nerd Font 10">' .. str .. "   " .. '</span>'
	end)

	awful.spawn.easy_async_with_shell(get_temp, function(out)
		local str = string.gsub(out, "%s+", "")
		temparature_text.markup = '<span color="' ..
			color.red .. '" font="Fira Code Nerd Font bold 24">' .. str .. '°C' .. '</span>'
	end)

	awful.spawn.easy_async_with_shell(get_humidity, function(out)
		local str = string.gsub(out, "%s+", "")
		humidity_text.markup = '<span color="' ..
			color.white .. '" font="Fira Code Nerd Font 10">' .. str .. " " .. '</span>'
	end)

	awful.spawn.easy_async_with_shell(get_feelslike, function(out)
		local str = string.gsub(out, "%s+", "")
		feels_like_text.markup = '<span color="' ..
			color.white .. '" font="Fira Code Nerd Font 10">' .. str .. "°C" .. '</span>'
	end)

	awful.spawn.easy_async_with_shell(get_wind, function(out)
		local str = string.gsub(out, "%s+", "")
		wind_text.markup = '<span color="' ..
			color.white .. '" font="Fira Code Nerd Font 10">' .. str .. " km/h" .. '</span>'
	end)

	awful.spawn.easy_async_with_shell(get_icon, function(out)
		local str = string.gsub(out, "%s+", "")
		local weather_image = iconpath .. 'd_rain.svg'

		if str == '50d' then
			weather_image = iconpath .. 'dmist.svg'
		elseif str == '01d' then
			weather_image = iconpath .. 'sun_icon.svg'
		elseif str == '01n' then
			weather_image = iconpath .. 'moon_icon.svg'
		elseif str == '02d' then
			weather_image = iconpath .. 'dfew_clouds.svg'
		elseif str == '02n' then
			weather_image = iconpath .. 'nfew_clouds.svg'
		elseif str == '03d' then
			weather_image = iconpath .. 'dscattered_clouds.svg'
		elseif str == '03n' then
			weather_image = iconpath .. 'nscattered_clouds.svg'
		elseif str == '04d' then
			weather_image = iconpath .. 'dbroken_clouds.svg'
		elseif str == '04n' then
			weather_image = iconpath .. 'nbroken_clouds.svg'
		elseif str == '09d' then
			weather_image = iconpath .. 'dshower_rain.svg'
		elseif str == '09n' then
			weather_image = iconpath .. 'nshower_rain.svg'
		elseif str == '010d' then
			weather_image = iconpath .. 'd_rain.svg'
		elseif str == '010n' then
			weather_image = iconpath .. 'n_rain.svg'
		elseif str == '011d' then
			weather_image = iconpath .. 'dthunderstorm.svg'
		elseif str == '011n' then
			weather_image = iconpath .. 'nthunderstorm.svg'
		elseif str == '013d' then
			weather_image = iconpath .. 'snow.svg'
		elseif str == '013n' then
			weather_image = iconpath .. 'snow.svg'
		elseif str == '50n' then
			weather_image = iconpath .. 'nmist.svg'
		elseif str == '...' then
			weather_image = iconpath .. 'weather-error.svg'
		end

		weath_image.image = weather_image
	end)
end

gears.timer({
	timeout = 3600,
	call_now = true,
	autostart = true,
	callback = update_timer,
})



-----------------------------
--Main Widget ---------------
-----------------------------

local weatherbox = wibox.widget {
	{
		{
			{
				{
					{
						city_text,
						country_text,
						layout = wibox.layout.fixed.horizontal
					},
					nil,
					weather_text,
					layout = wibox.layout.align.horizontal
				},
				widget = wibox.container.margin,
				-- margins = dpi(20),
				top = dpi(10),
				bottom = dpi(7),
				left = dpi(15),
				right = dpi(15)
			},
			{
				{
					temparature_text,
					nil,
					weath_image,
					layout = wibox.layout.align.horizontal
				},
				widget = wibox.container.margin,
				top = dpi(0),
				bottom = dpi(5),
				left = dpi(15),
				right = dpi(15),
			},
			{
				{
					humidity,
					{
						temp_feels_like,
						widget = wibox.container.margin,
						left = dpi(20),
						right = dpi(20)
					},
					wind,
					layout = wibox.layout.fixed.horizontal
				},
				widget = wibox.container.margin,
				top = dpi(0),
				bottom = dpi(10),
				left = dpi(15),
				right = dpi(15),
			},
			layout = wibox.layout.fixed.vertical
		},
		widget = wibox.container.background,
		bg = color.background_lighter,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 10)
		end,

	},
	widget = wibox.container.margin,
	top = dpi(0),
	bottom = dpi(0),
	left = dpi(12),
	right = dpi(12),
}

return weatherbox
