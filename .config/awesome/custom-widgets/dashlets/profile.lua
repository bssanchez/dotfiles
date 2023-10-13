local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("custom-widgets.color")
local user = require("custom-widgets.user_profile")

--Profile Image
local image = wibox.widget {
  image = user.image_path,
  widget = wibox.widget.imagebox,
  resize = true,
  forced_height = dpi(100),
  forced_width = dpi(100)
}

--Distro text
local text = '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. 'ArchLinux x86_64' .. '</span>'
local icon = '<span color="' .. color.red .. '" font="Fira Code Nerd Font bold 12">' .. '' .. '</span>'

local distro_text = wibox.widget {
  {
    -- text = user.name,
    markup = icon .. text,
    font = "Fira Code Nerd Font Bold 10",
    widget = wibox.widget.textbox,
    fg = color.white,
    -- forced_width = dpi(300),
  },
  widget = wibox.container.margin,
  top = dpi(5),
  bottom = dpi(5),
  right = dpi(5),
  left = dpi(25),
  forced_height = dpi(30)
}

-- Window Manager
local text2 = '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. 'Awesome WM' .. '</span>'
local icon2 = '<span color="' .. color.yellow .. '" font="Fira Code Nerd Font bold 12">' .. '' .. '</span>'

local wm_text = wibox.widget {
  {
    -- text = user.name,
    markup = icon2 .. text2,
    font = "Fira Code Nerd Font Bold 10",
    widget = wibox.widget.textbox,
    fg = color.white,
    -- forced_width = dpi(300),
  },
  widget = wibox.container.margin,
  top = dpi(5),
  bottom = dpi(5),
  right = dpi(5),
  left = dpi(25),
  forced_height = dpi(30)
}

--Uptime
local uptime = 3

local text3 = '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. uptime .. '</span>'
local icon3 = '<span color="' .. color.green .. '" font="Fira Code Nerd Font bold 14">' .. '󱎫' .. '</span>'

local uptime_textbox = wibox.widget {
  markup = icon3 .. text3,
  font = "Fira Code Nerd Font Bold 11",
  widget = wibox.widget.textbox,
  fg = color.white,
}

local uptime_text = wibox.widget {
  uptime_textbox,
  widget = wibox.container.margin,
  top = dpi(5),
  bottom = dpi(5),
  right = dpi(5),
  left = dpi(25),
  forced_height = dpi(30)
}

awful.spawn.easy_async("uptime -p", function(out)
  uptime_textbox.markup = icon3 .. '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. out:gsub("up ", "") .. '</span>'
end)

local update_uptime = function()
  awful.spawn.easy_async("uptime -p", function(out)
    uptime_textbox.markup = icon3 .. '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. out:gsub("up ", "") .. '</span>'
  end)
end

local update_uptime_timer = gears.timer({
  timeout = 60,
  call_now = true,
  autostart = true,
  callback = update_uptime,
})

--Main Widget
local profile = wibox.widget {
  {
    image,
    {
      {
        {
          {
            distro_text,
            wm_text,
            uptime_text,
            layout = wibox.layout.fixed.vertical
          },
          widget = wibox.container.margin,
          top = dpi(4),
          bottom = dpi(4),
          forced_width = dpi(410)
        },
        widget = wibox.container.background,
        bg = color.background_lighter,
        shape = function(cr, width, height)
          gears.shape.rounded_rect(cr, width, height, 10)
        end,

      },
      widget = wibox.container.margin,
      left = dpi(12)
    },
    layout = wibox.layout.fixed.horizontal
  },
  widget = wibox.container.margin,
  top = dpi(12),
  bottom = dpi(0),
  left = dpi(12),
  right = dpi(12),
  forced_width = dpi(350)
}

return profile
