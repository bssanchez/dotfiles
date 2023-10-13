local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("custom-widgets.color")

--Main widgets
---Ram
local text1 = '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. '16 GiB' .. '</span>'
local icon1 = '<span color="' .. color.red .. '" font="Fira Code Nerd Font bold 12">' .. '' .. '</span>'

local ram_usage = wibox.widget {
  markup = icon1 .. text1,
  font = "Fira Code Nerd Font Bold 11",
  widget = wibox.widget.textbox,
  fg = color.white,
}

local ram_text = wibox.widget {
  ram_usage,
  widget = wibox.container.margin,
  top = dpi(6),
  bottom = dpi(3),
  right = dpi(15),
  left = dpi(15),
  -- forced_height = dpi(40)
}

-- Fetch ram_usage info
awful.spawn.easy_async_with_shell([[ free -m | awk 'NR==2 {print $3}'
]], function(out)
  local str = string.gsub(out, "%s+", "")
  local val = tonumber(str) / 1000
  ram_usage.markup = icon1 .. '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. val .. ' GiB' .. '</span>'
end)

--Update ram_usage every time
local update_ram = function()
  awful.spawn.easy_async_with_shell([[ free -m | awk 'NR==2 {print $3}'
]], function(out)
    local str = string.gsub(out, "%s+", "")
    local val = tonumber(str) / 1000
    ram_usage.markup = icon1 .. '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. val .. ' GiB' .. '</span>'
  end)
end

gears.timer({
  timeout = 10,
  call_now = true,
  autostart = true,
  callback = update_ram
})


---Cpu----------------------
local text2 = '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. '1%' .. '</span>'
local icon2 = '<span color="' .. color.red .. '" font="Fira Code Nerd Font bold 12">' .. '' .. '</span>'

local cpu_usage = wibox.widget {
  -- text = user.name,
  markup = icon2 .. text2,
  font = "Fira Code Nerd Font Bold 11",
  widget = wibox.widget.textbox,
  fg = color.white,
  -- forced_width = dpi(300),
}

local cpu_text = wibox.widget {
  cpu_usage,
  widget = wibox.container.margin,
  top = dpi(3),
  bottom = dpi(3),
  right = dpi(15),
  left = dpi(15),
  -- forced_height = dpi(40)
}

-- Fetch cpu_usage info
awful.spawn.easy_async_with_shell([[ echo ""$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"
]], function(out)
  local str = string.gsub(out, "%s+", "")
  cpu_usage.markup = icon2 .. '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. str .. '</span>'
end)

--Update cpu_usage every time
local update_cpu = function()
  awful.spawn.easy_async_with_shell([[ echo ""$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"
]], function(out)
    local str = string.gsub(out, "%s+", "")
    cpu_usage.markup = icon2 .. '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. str .. '</span>'
  end)
end

gears.timer({
  timeout = 10,
  call_now = true,
  autostart = true,
  callback = update_cpu
})


---Storage----------------------
local text3 = '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. '69/334 GiB' .. '</span>'
local icon3 = '<span color="' .. color.red .. '" font="Fira Code Nerd Font bold 14">' .. '󰨣' .. '</span>'

local storage_usage = wibox.widget {
  markup = icon3 .. text3,
  font = "Fira Code Nerd Font Bold 11",
  widget = wibox.widget.textbox,
  fg = color.white,
}

local storage_text = wibox.widget {
  storage_usage,
  widget = wibox.container.margin,
  top = dpi(3),
  bottom = dpi(3),
  right = dpi(15),
  left = dpi(15),
}

-- Fetch storage_usage info
awful.spawn.easy_async_with_shell([[ df -h --total | tail -n 1 | awk '{print $3 "/" $4}'
]], function(out)
  local str = string.gsub(out, "%s+", "")
  storage_usage.markup = icon3 .. '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. str .. '</span>'
end)

--Update storage_usage every time
local update_storage = function()
  awful.spawn.easy_async_with_shell([[df -h --total | tail -n 1 | awk '{print $3 "/" $4}'
]], function(out)
    local str = string.gsub(out, "%s+", "")
    storage_usage.markup = icon3 .. '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. str .. '</span>'
  end)
end

gears.timer({
  timeout = 7200,
  call_now = true,
  autostart = true,
  callback = update_storage
})

---Package----------------------
local text4 = '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. '0' .. '</span>'
local icon4 = '<span color="' .. color.red .. '" font="Fira Code Nerd Font bold 12">' .. '󰏖' .. '</span>'

local package_count = wibox.widget {
  markup = icon4 .. text4,
  font = "Fira Code Nerd Font Bold 11",
  widget = wibox.widget.textbox,
  fg = color.white,
}

local packages_text = wibox.widget {
  package_count,
  widget = wibox.container.margin,
  top = dpi(3),
  bottom = dpi(6),
  right = dpi(15),
  left = dpi(15),
  -- forced_height = dpi(40)
}

awful.spawn.easy_async_with_shell([[pacman -Q | wc -l]], function(out)
  local str = string.gsub(out, "%s+", "")

  package_count.markup = icon4 .. '<span color="' .. color.white .. '" font="Fira Code Nerd Font 11">' .. '  : ' .. str .. '</span>'
end)

local Sys_info = wibox.widget {
  {
    {
      {
        ram_text,
        cpu_text,
        storage_text,
        packages_text,
        layout = wibox.layout.fixed.vertical
      },
      widget = wibox.container.place,
      halign = 'left'
    },
    widget = wibox.container.background,
    bg = color.background_lighter,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 10)
    end,

  },
  widget = wibox.container.margin,
  margins = dpi(12),
}

return Sys_info
