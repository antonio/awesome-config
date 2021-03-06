-- TODO:
-- Calendar widget
-- CPU widget
-- HD widget
-- Keyboard layout selector widget
-- - Refactor: scripts and code cleanup
-- - Keybinds should change between the us layouts only
-- - Maybe use signals so that depending on the window, the layout is chosen
-- - Display a selection menu on right click
-- Modularize, requiring files
-- MPD widget
-- Pacman widget
-- Volume widget (with bindings)

require("awful")
require("awful.remote")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")

require("safeinit")

-- {{{ Variable definitions
beautiful.init(awful.util.getdir("config") .. "/theme/theme.lua")
terminal = "urxvt"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
alt = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  awful.layout.suit.floating,
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
  -- Each screen has its own tag table.
  tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
powermenu = {
  { "Reload", awesome.restart },
  { "Quit", awesome.quit },
  { "Reboot", function() awful.util.spawn("gksudo reboot") end },
  { "Poweroff", function () awful.util.spawn("gksudo poweroff") end },
}

mainmenu = awful.menu({
  items = {
    { "Terminal", terminal },
    { "Chromium", function() awful.util.spawn("chromium") end},
    { "Power", powermenu },
  }
})

launcher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                   menu = mainmenu })
-- }}}

-- {{{ Wibox
separator = widget {type = "textbox"}
separator.text = " | "
-- Original version from http://awesome.naquadah.org/wiki/Change_keyboard_maps
kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
awful.util.spawn_with_shell("setxkbmap us && xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'")
kbdcfg.layout = { { "us", "", "en.png" }, { "us", "intl", "en.png" }, { "es", "", "es.png" } }
kbdcfg.current = 1
kbdcfg.code_widget = widget({ type = "textbox", align = "right" })
kbdcfg.code_widget.text = " " .. kbdcfg.layout[kbdcfg.current][1] .. kbdcfg.layout[kbdcfg.current][2]
kbdcfg.flags_widget = widget({ type = "imagebox", align = "right" })
kbdcfg.flags_widget.image = image(awful.util.getdir("config") .. "/art/" .. kbdcfg.layout[kbdcfg.current][3])
kbdcfg.switch = function ()
  kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
  local t = kbdcfg.layout[kbdcfg.current]
  kbdcfg.code_widget.text = " " .. t[1] .. " " .. t[2]
  kbdcfg.flags_widget.image = image(awful.util.getdir("config") .. "/art/" .. t[3])
  awful.util.spawn_with_shell(kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] .. " && xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'")
end


--pacman = {}
--pacman.tooltip_text = function ()
                         --update_list = awful.util.pread("echo -n $(pacman -Qu)")
                         --if update_list == "" then
                           --local ghost = "<span font='stlarch'></span>"
                           --return ghost .. " - Hooray! Nothing to update!"
                         --else
                           --return update_list
                         --end
                       --end
--pacman.display_info = function ()
                         --local icon = "<span font='stlarch'></span>"
                         --local value = awful.util.pread("echo -n $(pacman -Qu | wc -l)")
                         --pacman.tooltip:set_text(pacman.tooltip_text())
                         --return icon ..  " " .. value
                       --end
--pacman.timer = timer { timeout = 60 }
--pacman.timer:add_signal("timeout", function () pacman.widget.text = pacman.display_info() end)
--pacman.timer:start()
--pacman.widget = widget({ type = "textbox" })
--pacman.tooltip = awful.tooltip {}
--pacman.tooltip:add_to_object(pacman.widget)
--pacman.tooltip:set_text(pacman.tooltip_text())
--pacman.widget.text = pacman.display_info()

-- Battery widget
-- - Notify when power is low
-- - How to use unicode characters?
-- TODO: Modularize
battery = {}
battery.tooltip_text = function ()
                         return awful.util.pread("echo -n $(acpi -b)")
                       end
battery.display_info = function ()
                         local icon = awful.util.pread("battery_icon")
                         local value = awful.util.pread("battery")
                         battery.tooltip:set_text(battery.tooltip_text())
                         return "<span font=\'tamsynmod\'>" .. icon .. " </span>" .. value
                       end
battery.timer = timer { timeout = 60 }
battery.timer:add_signal("timeout", function () battery.widget.text = battery.display_info() end)
battery.timer:start()
battery.widget = widget({ type = "textbox" })
battery.tooltip = awful.tooltip {}
battery.tooltip:add_to_object(battery.widget)
battery.tooltip:set_text(battery.tooltip_text())
battery.widget.text = battery.display_info()

temperature = {}
temperature.tooltip_text = function ()
                             return awful.util.pread("echo -n $(sensors | grep 'Core 0')")
                           end
temperature.display_info = function ()
                         local icon = "±"
                         local value = awful.util.pread("sensors | grep 'Core 0' | awk {'print $3'}")
                         temperature.tooltip:set_text(temperature.tooltip_text())
                         return "<span font=\'tamsynmod\'>" .. icon .. " </span>" .. value
                       end
temperature.timer = timer { timeout = 60 }
temperature.timer:add_signal("timeout", function () temperature.widget.text = temperature.display_info() end)
temperature.timer:start()
temperature.widget = widget({ type = "textbox" })
temperature.tooltip = awful.tooltip {}
temperature.tooltip:add_to_object(temperature.widget)
temperature.tooltip:set_text(temperature.tooltip_text())
temperature.widget.text = temperature.display_info()

memory = {}
memory.tooltip_text = function()
                        return awful.util.pread("\n" .. "free -h | col -x")
                      end
memory.display_info = function ()
                         local icon = "þ"
                         local value = awful.util.pread("free -h | grep Mem | awk {'print $4 \"/\" $2'}")
                         memory.tooltip:set_text(memory.tooltip_text())
                         return "<span font=\'tamsynmod\'>" .. icon .. " </span>" .. value
                       end
memory.timer = timer { timeout = 60 }
memory.timer:add_signal("timeout", function () memory.widget.text = memory.display_info() end)
memory.timer:start()
memory.widget = widget({ type = "textbox" })
memory.tooltip = awful.tooltip {}
memory.tooltip:add_to_object(memory.widget)
memory.tooltip:set_text(memory.tooltip_text())
memory.widget.text = memory.display_info()

-- Mouse bindings
kbdcfg.code_widget:buttons(awful.util.table.join(
awful.button({ }, 1, function () kbdcfg.switch() end)
))
-- Create a textclock widget
textclock = awful.widget.textclock({ align = "right" }, "%d/%m/%y %H:%M")

-- Create a systray
systray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
wibox = {}
promptbox = {}
layoutbox = {}
taglist = {}
taglist.buttons = awful.util.table.join(
                    awful.button({}, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({}, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({}, 4, awful.tag.viewnext),
                    awful.button({}, 5, awful.tag.viewprev))
tasklist = {}
tasklist.buttons = awful.util.table.join(
                     awful.button({}, 1, function (c)
                                           if c == client.focus then
                                             c.minimized = true
                                           else
                                             if not c:isvisible() then
                                               awful.tag.viewonly(c:tags()[1])
                                             end
                                             -- This will also un-minimize
                                             -- the client, if needed
                                             client.focus = c
                                             c:raise()
                                           end
                                         end),
                     awful.button({}, 3, function ()
                                            if instance then
                                              instance:hide()
                                              instance = nil
                                            else
                                              instance = awful.menu.clients({ width=250 })
                                            end
                                          end),
                     awful.button({}, 4, function ()
                                           awful.client.focus.byidx(1)
                                           if client.focus then client.focus:raise() end
                                          end),
                     awful.button({}, 5, function ()
                                           awful.client.focus.byidx(-1)
                                           if client.focus then client.focus:raise() end
                                         end))

for s = 1, screen.count() do
  -- Create a promptbox for each screen
  promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  layoutbox[s] = awful.widget.layoutbox(s)
  layoutbox[s]:buttons(awful.util.table.join(
                         awful.button({}, 1, function () awful.layout.inc(layouts, 1) end),
                         awful.button({}, 3, function () awful.layout.inc(layouts, -1) end),
                         awful.button({}, 4, function () awful.layout.inc(layouts, 1) end),
                         awful.button({}, 5, function () awful.layout.inc(layouts, -1) end)))
  -- Create a taglist widget
  taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)

  -- Create a tasklist widget
  tasklist[s] = awful.widget.tasklist(function(c)
    return awful.widget.tasklist.label.currenttags(c, s)
  end, tasklist.buttons)

  -- Create the wibox
  wibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })
  -- Add widgets to the wibox - order matters
  wibox[s].widgets = {
    {
      launcher,
      taglist[s],
      promptbox[s],
      layout = awful.widget.layout.horizontal.leftright
    },
    layoutbox[s],
    separator,
    textclock,
    separator,
    s == 1 and systray or nil,
    separator,
    kbdcfg.code_widget,
    kbdcfg.flags_widget,
    separator,
    battery.widget,
    separator,
    temperature.widget,
    separator,
    memory.widget,
    separator,
    --pacman.widget,
    --separator,
    tasklist[s],
    layout = awful.widget.layout.horizontal.rightleft
  }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
  awful.button({}, 3, function () mainmenu:toggle() end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  awful.key({ modkey, }, "Left",   awful.tag.viewprev),
  awful.key({ modkey, }, "Right",  awful.tag.viewnext),
  awful.key({ modkey, }, "Escape", awful.tag.history.restore),

  awful.key({ modkey, }, "j",
    function ()
      awful.client.focus.byidx( 1)
      if client.focus then client.focus:raise() end
    end),
  awful.key({ modkey, }, "k",
    function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
    end),
  awful.key({ modkey, }, "q", function () mainmenu:show({keygrabber=true}) end),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
  awful.key({ modkey,           }, "Tab", function ()
                                            awful.client.focus.history.previous()
                                            if client.focus then
                                              client.focus:raise()
                                            end
                                          end),

  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit),

  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
  awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

  awful.key({ "Control", alt }, "l", function() awful.util.spawn('slock') end),
  awful.key({ "Control", alt }, "s", function() awful.util.spawn('systemctl suspend') end),

  -- Prompt
  awful.key({ modkey }, "r", function () promptbox[mouse.screen]:run() end),

  awful.key({ modkey }, "x", function ()
                               awful.prompt.run({ prompt = "Run Lua code: " },
                               promptbox[mouse.screen].widget,
                               awful.util.eval, nil,
                               awful.util.getdir("cache") .. "/history_eval")
                             end))

clientkeys = awful.util.table.join(
  awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
  awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
  awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
  awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
  awful.key({ "Shift" }, "Shift_R", function () kbdcfg.switch() end),
  awful.key({ modkey,           }, "m",      function (c)
                                               c.maximized_horizontal = not c.maximized_horizontal
                                               c.maximized_vertical   = not c.maximized_vertical
                                             end))

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
  keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
  globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9,
     function ()
       local screen = mouse.screen
       if tags[screen][i] then
         awful.tag.viewonly(tags[screen][i])
       end
     end
    ),

    awful.key({ modkey, "Control" }, "#" .. i + 9,
      function ()
        local screen = mouse.screen
        if tags[screen][i] then
          awful.tag.viewtoggle(tags[screen][i])
        end
      end
    ),

    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function ()
        if client.focus and tags[client.focus.screen][i] then
          awful.client.movetotag(tags[client.focus.screen][i])
        end
      end
    ),

    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
    function ()
      if client.focus and tags[client.focus.screen][i] then
        awful.client.toggletag(tags[client.focus.screen][i])
      end
    end)
  )
end

clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
  {
    rule = { class = "Gcr-prompter" },
    properties = { floating = true, ontop = true },
    callback = awful.placement.centered
  },
  {
    rule = { class = "URxvt" },
    properties = { size_hints_honor = false },
  },
  {
    rule = { class = "Emacs" },
    properties = { size_hints_honor = false },
  },
  {
    rule = { class = "Exe" }, -- Chromium full screen videos
    properties = { floating =true },
  },
  -- All clients will match this rule.
  {
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = true,
      keys = clientkeys,
      buttons = clientbuttons }
  },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
  -- Add a titlebar
  -- awful.titlebar.add(c, { modkey = modkey })

  -- Enable sloppy focus
  c:add_signal("mouse::enter", function(c)
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
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

