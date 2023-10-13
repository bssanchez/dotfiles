--[[
    Transhade Awesome WM config 1.0 
    by @_kid_goth
--]]

-- If LuaRocks is installed, make sure that packages installed through it are
pcall(require, "luarocks.loader")

-- {{{ Required libraries
local gears         =   require("gears")
local awful         =   require("awful")
                        require("awful.autofocus")
local wibox         =   require("wibox")
local beautiful     =   require("beautiful")
local naughty       =   require("naughty")
local menubar       =   require("menubar")
local hotkeys_popup =   require("awful.hotkeys_popup").widget
                        require("awful.hotkeys_popup.keys")
local lain          =   require("lain")
local dpi           =   beautiful.xresources.apply_dpi
-- }}}


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, hubo un error durante el inicio!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, ocurrió un error!",
            text = err
        })
        in_error = false
    end)
end
-- }}}


-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- define home path
local homedir = os.getenv("HOME") .. "/.config/awesome/"

-- init theme
local confdir = homedir .. "themes/transhade/"
beautiful.init(confdir .. "theme.lua")

-- teclas de mod y terminal
local modkey      = "Mod4"
local altkey      = "Mod1"

-- aplicaciones predeterminadas
local browser     = "brave-nightly"
local gui_editor  = "gvim"
local file_manager= "pcmanfm"
local terminal    = "alacritty"
local editor      = os.getenv("EDITOR") or "vim"
local editor_cmd  = terminal .. " -e " .. editor
-- }}}


-- {{{ Layouts config
--
lain.layout.termfair.nmaster   = 3
lain.layout.termfair.ncol      = 1
lain.layout.centerwork.nmaster = 3
lain.layout.centerwork.ncol    = 1

awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral
}
-- }}}


-- {{{ Helper functions
--
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}


-- {{{ Menu
--
local myawesomemenu = {
    {
		"Hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "Manual",          terminal .. " -e man awesome" },
	{ "Edit config",     editor_cmd .. " " .. awesome.conffile },
	{ "Terminal",        terminal },
	{ "Restart",         awesome.restart },
	{
		"Quit",
		function()
			awesome.quit()
		end,
	},
}

local mymainmenu = awful.menu({ 
    items = { 
        { "Awesome", myawesomemenu, beautiful.awesome_icon_launcher },
        { "File manager", file_manager },
        { "Open Terminal", terminal },
        { "Shutdown/Logout", "clearine" },
    },
    theme = {
		width = 180,
		height = 25,
		font = "Fira Code Nerd Font 10",
		fg_normal = beautiful.fg_normal,
		fg_focus = beautiful.fg_focus,
		bg_normal = beautiful.bg_normal,
		bg_focus = beautiful.bg_focus,
		border_width = 3,
		border_color = beautiful.border_normal,
	},
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon_launcher, menu = mymainmenu })
menubar.utils.terminal = terminal
-- }}}


-- {{{ Notifications
--
require("custom-widgets.notifications")
-- }}}


-- {{{ Wibar & Wibox (Widgets)
--
--Spacer
local separator = wibox.widget.textbox(" ")

-- Brightness Osd functionality
local brightness_osd   = require("custom-widgets.osds.brightness_osd")
local brightness_timer = gears.timer {
	timeout = 2,
	autostart = true,
	callback = function()
		brightness_osd.visible = false
	end
}

brightness_osd:connect_signal("mouse::enter", function()
	brightness_timer:stop()    -- Stop the timer when the mouse enters the dock
	brightness_osd.visible = true -- Show the dock immediately
end)

-- Attach the timer to a signal that triggers when the mouse leaves the dock
brightness_osd:connect_signal("mouse::leave", function()
	brightness_timer:again() -- Restart the timer when the mouse leaves the dock
end)

-- Volume Osd functionality
local volume_osd   = require("custom-widgets.osds.volume_osd")
local volume_timer = gears.timer {
	timeout = 2,
	autostart = true,
	callback = function()
		volume_osd.visible = false
	end
}

volume_osd:connect_signal("mouse::enter", function()
	volume_timer:stop()    -- Stop the timer when the mouse enters the dock
	volume_osd.visible = true -- Show the dock immediately
end)

-- Attach the timer to a signal that triggers when the mouse leaves the dock
volume_osd:connect_signal("mouse::leave", function()
	volume_timer:again() -- Restart the timer when the mouse leaves the dock
end)

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Clock
local calendar_widget = require("custom-widgets.calendar")
local mytextclock = wibox.widget.textclock('<span color="' .. beautiful.fg_normal .. '" font="Fira Code Nerd Font Medium 9"> %a %b %d, %I:%M %p </span>', 10)

-- calendar-widget
local cw = calendar_widget({
	theme = "orangeblood",
	placement = "top_center",
	start_sunday = true,
	radius = 8,
	previous_month_button = 1,
	padding = 5,
	next_month_button = 3,
})
mytextclock:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		cw.toggle()
	end
end)

-- Awesome logo
local awesome_logo = require("custom-widgets.awesome_logo")

-- Battery widget
local batteryarc_widget = require("custom-widgets.batteryarc")


-- {{{ Random Wallpapers
-- Get the list of files from a directory. Must be all images or folders and non-empty. 
local function scanDir(directory)
    local i, fileList, popen = 0, {}, io.popen
    for filename in popen([[find "]] ..directory.. [[" -type f]]):lines() do
        i = i + 1
        fileList[i] = filename
    end
    return fileList
end

local wallpaperList = scanDir(beautiful.wallpaper)
local changeTime = 300

-- Apply a random wallpaper on startup.
math.randomseed(os.time())
local numRandWall = math.random(1, #wallpaperList)

if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(wallpaperList[numRandWall], s, true)
    end
end

-- Apply a random wallpaper every changeTime seconds.
local wallpaperTimer = timer { timeout = changeTime }
wallpaperTimer:connect_signal("timeout", function()
    numRandWall = math.random(1, #wallpaperList)

    for s = 1, screen.count() do
        gears.wallpaper.maximized(wallpaperList[numRandWall], s, true)
    end
    -- stop the timer (we don't need multiple instances running at the same time)
    wallpaperTimer:stop()

    --restart the timer
    wallpaperTimer.timeout = changeTime
    wallpaperTimer:start()
end)

-- initial start when rc.lua is first run
wallpaperTimer:start()
-- }}}

local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons  = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 3, client_menu_toggle_fn()),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)

-- for s = 1, screen.count() do
awful.screen.connect_for_each_screen(function(s)
    awful.tag(
        -- { " files ", " code ", " web ", " shell ", " media " },
        { "  ", "  ", "  ", "  ", "  " },
        s, {
        awful.layout.layouts[1],
        awful.layout.layouts[1],
        awful.layout.layouts[1],
        awful.layout.layouts[4],
        awful.layout.layouts[3]
    })

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 2, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end),
        awful.button({ }, 6, function () awful.layout.inc( 1) end)
    ))
    
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s, 
        filter  = awful.widget.taglist.filter.all, 
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist  = awful.widget.tasklist {
        screen  = s, 
        filter  = awful.widget.tasklist.filter.currenttags, 
        buttons = tasklist_buttons,
        style = {
            -- shape_border_width = 1,
            -- shape_border_color = beautiful.tasklist_fg_normal,
            -- shape  = gears.shape.rectangle,
            align = "center",
        }
    }
    
    -- Create the top wiboxs
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        margins = { top = dpi(0), left = dpi(0), right = dpi(0), bottom = dpi(0) },
        width = 1920,
        height = 26,
        bg =  beautiful.bg_normal,
        y = 0,
        border_color = "00000000",
    })

    s.mywibox.x = 0
	s.mywibox.y = 0

    local top_right = require("custom-widgets.top_right")
    local taglist_widget = wibox.widget {
        {
            s.mytaglist,
            left   = 10,
            top    = 5,
            bottom = 5,
            right  = 10,
            widget = wibox.container.margin,
        },
        bg         = beautiful.bg_taglist,
        shape      = gears.shape.rounded_rect,
        shape_clip = true,
        widget     = wibox.container.background,
    }

    s.padding = {
        top = 2, 
        left = 2, 
        right = 2, 
        bottom = 2, 
    }

    -- Add widgets to the wibox
    s.mywibox:setup {
        {
            layout = wibox.layout.stack,
            expand = "none",
            {
                layout = wibox.layout.align.horizontal,
                { -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                    separator,
                    awesome_logo,
                    separator,
                    taglist_widget,
                    separator,
                    s.mylayoutbox,
                    separator,
                    s.mypromptbox,
                },
                nil, -- Middle widget
                { -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    separator,
                    
                    top_right,
                    separator,
                    batteryarc_widget({
                        show_current_level = true,
                        arc_thickness = 3,
                        size = 10,
                        font = "Fira Code Nerd Font 6",
                        timeout = 10,
                    }),
                    separator,
                }
            },
            {
                mytextclock,
                valign = "center",
                halign = "center",
                layout = wibox.container.place,
            }
        },
        widget = wibox.container.margin,
        bg = beautiful.bg_normal,
        top = dpi(2),
        bottom = dpi(2),
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 0)
        end,
    }
    
    -- Create the bottom wibox
    s.mywiboxbottom = awful.wibar({ 
        position = "bottom", 
        screen = s, 
        width = 1920,
        height = 24,
        bg = "#323232",
        border_color = "00000000"
    })

    s.mywiboxbottom.x = 0
    s.mywiboxbottom.y = 1080 - s.mywiboxbottom.height

    if s.index == 2 then
        s.mywiboxbottom.x = 1920
    end

    local netspeed_widget = require("custom-widgets.net-speed")
    local systray = require("custom-widgets.systray")

    -- Add widgets to the bottom wibox
    s.mywiboxbottom:setup {
        layout = wibox.layout.align.horizontal,
        nil,
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget {
				widget = wibox.widget.separator,
				forced_width = 8,
				opacity = 0
			},
            systray,
            separator,
            netspeed_widget(),
            separator
        },
    }

end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    -- Hotkeys
    awful.key({ modkey, }, "s",      hotkeys_popup.show_help, { description="show help", group="awesome" }),
    -- Tag browsing
    awful.key({ modkey, }, "Left",   awful.tag.viewprev, { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right",  awful.tag.viewnext, { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
    -- awful.key({ modkey, }, "<", function() awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible end, { description = "toggle systray visibility", group = "custom" }),

    -- Non-empty tag browsing
    awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end, { description = "view previous nonempty", group = "tag" }),
    awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end, { description = "view previous nonempty", group = "tag" }),

    -- Default client focus
    awful.key({ altkey, }, "j", function () awful.client.focus.byidx( 1) end, {description = "focus next by index", group = "client"}),
    awful.key({ altkey,           }, "k", function () awful.client.focus.byidx(-1) end, { description = "focus previous by index", group = "client" }),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
            {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
            {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
            {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
            {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
            {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
            {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Shift"  }, "o", awful.client.movetoscreen,
            {description = "move focused window between screens", group = "screen"}),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        for s in screen do
            s.mywibox.visible       = not s.mywibox.visible
            s.mywiboxbottom.visible = not s.mywiboxbottom.visible
        end
    end),

    -- Rename tag
    awful.key({ altkey, "Shift"   }, "r", function () lain.util.rename_tag() end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
            {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "BackSpace", function () awful.util.spawn('pcmanfm') end),
    awful.key({ modkey, "Shift"   }, "x", function () awful.util.spawn('xscreensaver-command -lock') end),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
            {description = "reload awesome", group = "awesome"}),
    -- awful.key({ modkey, "Shift"   }, "q", awesome.quit,
    --          {description = "quit awesome", group = "awesome"}),

    awful.key({ altkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
            {description = "increase master width factor", group = "layout"}),
    awful.key({ altkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
            {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
            {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
            {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
            {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
            {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
            {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
            {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
            function ()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    client.focus = c
                    c:raise()
                end
            end,
            {description = "restore minimized", group = "client"}),

    -- Dropdown application
    awful.key({ modkey, }, "z", function () awful.screen.focused().quake:toggle() end),

    -- ALSA volume control
    awful.key({ }, "#123", 
        function () 
            awful.util.spawn("amixer -D pulse sset Master 2%+")
            volume_osd.visible = true
            volume_timer:again()
        end),
    awful.key({ altkey }, "Up",
        function ()
            awful.util.spawn("amixer -D pulse sset Master 2%+")
            volume_osd.visible = true
            volume_timer:again()
        end),
    awful.key({ }, "#122", 
        function ()
            awful.util.spawn("amixer -D pulse sset Master 2%-")
            volume_osd.visible = true
            volume_timer:again()
        end),
    awful.key({ altkey }, "Down",
        function ()
            awful.util.spawn("amixer -D pulse sset Master 2%-")
            volume_osd.visible = true
            volume_timer:again()
        end),
    awful.key({ }, "#121", function () awful.util.spawn("amixer -D pulse sset Master toggle") end),
    awful.key({ altkey }, "m", function () awful.util.spawn("amixer -q set Master toggle") end),

    -- Bloquear pantalla
    awful.key({ modkey, altkey }, "l",
        function ()
            awful.util.spawn("xscreensaver-command -lock")
        end),

    -- brightness Control
    awful.key({ }, "#233", 
        function () 
            awful.util.spawn("light -A 10")
            brightness_osd.visible = true
			brightness_timer:again()
        end),
    awful.key({ altkey, "Control" }, "Up",
        function ()
            awful.util.spawn("light -A 10")
            brightness_osd.visible = true
			brightness_timer:again()
        end),
    awful.key({ }, "#232", 
        function ()
            awful.util.spawn("light -U 10")
            brightness_osd.visible = true
            brightness_timer:again()
        end),
    awful.key({ altkey, "Control" }, "Down",
        function ()
            awful.util.spawn("light -U 10")
            brightness_osd.visible = true
			brightness_timer:again()
        end),

    -- Copy to clipboard
    awful.key({ modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end), 

    -- User programs
    awful.key({ modkey }, "q", function () awful.spawn(browser) end),
    awful.key({ modkey }, "e", function () awful.spawn(gui_editor) end),

    -- Default
    awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end, {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "x",
        function ()
            awful.prompt.run {
            prompt       = "Run Lua code: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {description = "lua execute prompt", group = "awesome"}),
    awful.key({ modkey }, "p", function() awful.util.spawn("rofi -modi window,drun,ssh,combi -show combi")  end, {description = "show the menubar rofi", group = "launcher"}),
    -- awful.key({ modkey, "Shift" }, "p", function() menubar.show() end, {description = "show the menubar", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "s", function() awful.util.spawn("dunstify -t 15000 \"CheatSheet\" \"$(cat ~/.cheatsheet)\" >/dev/null 2>&1")  end, {description = "show hints/help from ~/.cheatsheet", group = "launcher"})
    --]]
)

clientkeys = gears.table.join(
    awful.key({ altkey, "Shift"   }, "m",      lain.util.magnify_client                         ),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
            {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
            {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
            {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
            {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
            {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = { border_width = beautiful.border_width,
                        border_color = beautiful.border_normal,
                        focus = awful.client.focus.filter,
                        raise = true,
                        keys = clientkeys,
                        buttons = clientbuttons,
                        screen = awful.screen.focused
        }
    },
    
    -- tag_names: " 一 ", " 二 ", " 三 ", " 四 ", " 五 " or use awful.screen.focused().tags[#TAG_INDEX]
    { rule_any = { class = { 
        "^PCManFM",
        "^Pcmanfm",
        "^pcmanfm"
    } }, properties = { screen = awful.screen.focused, tag = awful.screen.focused().tags[1] } },
    { rule_any = { class = { 
        "^Subl",
        "^subl",
        "^NetBeans",
        "^Netbeans",
        "^netbeans",
        "^Apache NetBeans",
        "^Code"
    } }, properties = { screen = awful.screen.focused, tag = awful.screen.focused().tags[2] } },
    { rule_any = { class = {
        "^Firefox",
        "^firefox",
        "^Chromium",
        "^chromium",
        "^brave",
        "^Brave",
        "^Google",
        "^google"
    } }, properties = { screen = awful.screen.focused, tag = awful.screen.focused().tags[3] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    -- Enable sloppy focus
    c:connect_signal("mouse::click", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false 
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = gears.table.join(
            awful.button({ }, 1, function()
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
            end),
            awful.button({ }, 3, function()
                client.focus = c
                c:raise()
                awful.mouse.client.resize(c)
            end)
        )

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(awful.titlebar.widget.iconwidget(c))
    left_layout:buttons(buttons)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_width = 0
        -- no borders if only 1 client visible
        elseif #awful.client.visible(mouse.screen) > 1 then
            c.border_width = beautiful.border_width
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
