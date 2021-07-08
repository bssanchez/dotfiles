--[[
    TranShade Awesome WM config 1.0 
--]]

local gears = require("gears")

local taglist_types = {
    "bubbles",        -- 1
    "sticks",         -- 2
}

local chosen_taglist_type = taglist_types[2]
local theme               = {}
theme.dir                 = os.getenv("HOME") .. "/.config/awesome/themes/transhade"

theme.icons               = theme.dir .. "/icons"
theme.wallpaper           = os.getenv("HOME") .. "/Imágenes/fondos"
theme.panel               = "png:" .. theme.icons .. "/panel/panel.png"
theme.font                = "Fira Code Nerd Font Medium 9"
theme.calendar_font       = "Fira Code Nerd Font 10"
theme.fs_font             = "Fira Code Nerd Font 10"

theme.awesome_icon_launcher = theme.icons .. "/awesome_icon.png"

theme.fg_normal           = "#FFFFFF"
theme.fg_focus            = "#D41919"
theme.fg_urgent           = "#CC9393"
theme.bat_fg_critical     = "#232323"

theme.bg_normal            = "#323232"
theme.bg_focus             = "#202020"
theme.bg_urgent            = "#D4191955"
theme.bg_systray           = "#323232"
theme.systray_icon_spacing = 10
theme.bat_bg_critical      = "#D4191955"

theme.clockgf             = "#d5d5c3"

-- Borders

theme.border_width  = 1
theme.border_normal = "#3F3F3F00"
theme.border_focus  = "#6F6F6F00"
theme.border_marked = "#CC939300"

-- Menu

theme.menu_height       = 18
theme.menu_width        = 160
theme.menu_icon_size    = 32

-- Notifications
theme.notification_font         = "JetBrains Mono 10"
theme.notification_bg           = "#323232"
theme.notification_fg           = "#ffffff"
theme.notification_border_width = 0
theme.notification_border_color = "#ffffff"
theme.notification_shape        = gears.shape.rectangle
theme.notification_opacity      = 1
theme.notification_margin       = 30
theme.notification_icon_size    = 64

-- Layout

theme.layout_floating   = theme.icons .. "/panel/layouts/floating.png"
theme.layout_tile       = theme.icons .. "/panel/layouts/tile.png"
theme.layout_tileleft   = theme.icons .. "/panel/layouts/tileleft.png"
theme.layout_tilebottom = theme.icons .. "/panel/layouts/tilebottom.png"
theme.layout_tiletop    = theme.icons .. "/panel/layouts/tiletop.png"
theme.layout_fairv      = theme.icons .. "/panel/layouts/fairv.png"
theme.layout_fairh      = theme.icons .. "/panel/layouts/fairh.png"
theme.layout_spiral     = theme.icons .. "/panel/layouts/spiral.png"

-- Taglist

theme.taglist_bg_empty    = "png:" .. theme.icons .. "/panel/taglist/" .. chosen_taglist_type .. "/empty.png"
theme.taglist_bg_occupied = "png:" .. theme.icons .. "/panel/taglist/" .. chosen_taglist_type .. "/occupied.png"
theme.taglist_bg_urgent   = "png:" .. theme.icons .. "/panel/taglist/" .. chosen_taglist_type .. "/urgent.png"
theme.taglist_bg_focus    = "png:" .. theme.icons .. "/panel/taglist/" .. chosen_taglist_type .. "/focus.png"
theme.taglist_font        = "Font Awesome 9"

-- Tasklist

theme.tasklist_font                 = "Fira Code Nerd Font Medium 9"
theme.tasklist_disable_icon         = true
--theme.tasklist_disable_text			- false
-- theme.tasklist_bg_normal            = "png:" .. theme.icons .. "/panel/tasklist/normal.png"
-- theme.tasklist_bg_focus             = "png:" .. theme.icons .. "/panel/tasklist/focus.png"
-- theme.tasklist_bg_urgent            = "png:" .. theme.icons .. "/panel/tasklist/urgent.png"
theme.tasklist_fg_focus             = "#CCCCCC"
theme.tasklist_fg_urgent            = "#EEEEEE"
theme.tasklist_fg_normal            = "#FFFFFF"
theme.tasklist_floating             = ""
theme.tasklist_sticky               = ""
theme.tasklist_ontop                = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

-- Widget

theme.widget_display   = theme.icons .. "/panel/widgets/display/widget_display.png" .. "00"
theme.widget_display_r = theme.icons .. "/panel/widgets/display/widget_display_r.png" .. "00"
theme.widget_display_c = theme.icons .. "/panel/widgets/display/widget_display_c.png" .. "00"
theme.widget_display_l = theme.icons .. "/panel/widgets/display/widget_display_l.png" .. "00"

-- MPD

theme.mpd_prev  = theme.icons .. "/panel/widgets/mpd/mpd_prev.png"
theme.mpd_nex   = theme.icons .. "/panel/widgets/mpd/mpd_next.png"
theme.mpd_stop  = theme.icons .. "/panel/widgets/mpd/mpd_stop.png"
theme.mpd_pause = theme.icons .. "/panel/widgets/mpd/mpd_pause.png"
theme.mpd_play  = theme.icons .. "/panel/widgets/mpd/mpd_play.png"
theme.mpd_sepr  = theme.icons .. "/panel/widgets/mpd/mpd_sepr.png"
theme.mpd_sepl  = theme.icons .. "/panel/widgets/mpd/mpd_sepl.png"

-- Separators

theme.spr    = theme.icons .. "/panel/separators/spr.png"
theme.sprtr  = theme.icons .. "/panel/separators/sprtr.png"
theme.spr4px = theme.icons .. "/panel/separators/spr4px.png"
theme.spr5px = theme.icons .. "/panel/separators/spr5px.png"

-- Clock / Calendar

theme.widget_clock = theme.icons .. "/panel/widgets/widget_clock.png"
theme.widget_cal   = theme.icons .. "/panel/widgets/widget_cal.png"

-- CPU / TMP

theme.widget_cpu    = theme.icons .. "/panel/widgets/widget_cpu.png"
-- theme.widget_tmp = theme.icons .. "/panel/widgets/widget_tmp.png"

-- MEM

theme.widget_mem = theme.icons .. "/panel/widgets/widget_mem.png"

-- FS

theme.widget_fs     = theme.icons .. "/panel/widgets/widget_fs.png"
theme.widget_fs_hdd = theme.icons .. "/panel/widgets/widget_fs_hdd.png"

-- Mail

theme.widget_mail = theme.icons .. "/panel/widgets/widget_mail.png"

-- NET

theme.widget_netdl = theme.icons .. "/panel/widgets/widget_netdl.png"
theme.widget_netul = theme.icons .. "/panel/widgets/widget_netul.png"

-- Battery
theme.widget_ac             = theme.icons .. "/panel/widgets/battery/ac.png"
theme.widget_battery        = theme.icons .. "/panel/widgets/battery/battery.png"
theme.widget_battery_low    = theme.icons .. "/panel/widgets/battery/battery_low.png"
theme.widget_battery_empty  = theme.icons .. "/panel/widgets/battery/battery_empty.png"

-- Misc

theme.menu_submenu_icon = theme.icons .. "/submenu.png"
theme.chrome         = theme.dir .. "/icons/apps/chrome.png"

-- Hotkeys
theme.hotkeys_bg                = '#323232'
theme.hotkeys_fg	            = '#FFFFFF'
theme.hotkeys_border_width      = 1
theme.hotkeys_border_color      = '#FFFFFF'
theme.hotkeys_shape             = gears.shape.rectangle
theme.hotkeys_modifiers_fg	    = '#D41919'
theme.hotkeys_label_bg	        = '#FFFFFF'
theme.hotkeys_label_fg	        = '#000000'
theme.hotkeys_font              = 'Fira Code Nerd Font Bold 9'
theme.hotkeys_description_font  = 'Fira Code Nerd Font Bold 9'
theme.hotkeys_group_margin      = 10

-- Titlebar
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"

theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.svg"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.svg"

theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.svg"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.svg"

theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.svg"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.svg"

theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.svg"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.svg"

theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.svg"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.svg"

theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"

theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"


return theme
