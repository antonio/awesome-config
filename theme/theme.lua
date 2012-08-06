local awful = require('awful')
theme = {}

theme.font = "Ubuntu Sans Mono 8"
theme.taglist_font = "Ubuntu Sans Mono 8"

theme.bg_normal = "#242424"
theme.bg_focus = "#242424"
theme.bg_urgent = "#242424"
theme.bg_minimize = "#242424"

theme.fg_normal = "#aaaaaa"
theme.fg_focus = "#dddddd"
theme.fg_urgent = "#f20024"
theme.fg_minimize = "#ffffff"

theme.border_width = "1"
theme.border_normal = "#000000"
theme.border_focus = "#535d6c"
theme.border_marked = "#91231c"

theme.taglist_fg_focus = "#a4c433"
theme.taglist_bg_focus = "#454545"
theme.taglist_bg_urgent = "#373737"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

theme.tooltip_font = theme.font
theme.tooltip_fg_color = theme.fg_normal
theme.tooltip_bg_color = theme.bg_normal

-- Display the taglist squares
theme.taglist_squares_sel   = awful.util.getdir("config") .. "/theme/taglist/squarefw.png"
theme.taglist_squares_unsel = awful.util.getdir("config") .. "/theme/taglist/squarew.png"
theme.tasklist_floating_icon = awful.util.getdir("config") .. "/theme/tasklist/floatingw.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = awful.util.getdir("config") .. "/theme/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = awful.util.getdir("config") .. "/theme/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = awful.util.getdir("config") .. "/theme/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = awful.util.getdir("config") .. "/theme/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = awful.util.getdir("config") .. "/theme/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = awful.util.getdir("config") .. "/theme/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = awful.util.getdir("config") .. "/theme/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = awful.util.getdir("config") .. "/theme/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = awful.util.getdir("config") .. "/theme/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = awful.util.getdir("config") .. "/theme/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = awful.util.getdir("config") .. "/theme/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = awful.util.getdir("config") .. "/theme/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = awful.util.getdir("config") .. "/theme/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = awful.util.getdir("config") .. "/theme/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = awful.util.getdir("config") .. "/theme/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = awful.util.getdir("config") .. "/theme/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = awful.util.getdir("config") .. "/theme/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = awful.util.getdir("config") .. "/theme/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = awful.util.getdir("config") .. "/theme/titlebar/maximized_focus_active.png"

-- You can use your own command to set your wallpaper
theme.wallpaper_cmd = { "feh --bg-center " .. awful.util.getdir("config") .. "/theme/background.png" }

-- You can use your own layout icons like this:
theme.layout_fairh = awful.util.getdir("config") .. "/theme/layouts/fairhw.png"
theme.layout_fairv = awful.util.getdir("config") .. "/theme/layouts/fairvw.png"
theme.layout_floating  = awful.util.getdir("config") .. "/theme/layouts/floatingw.png"
theme.layout_magnifier = awful.util.getdir("config") .. "/theme/layouts/magnifierw.png"
theme.layout_max = awful.util.getdir("config") .. "/theme/layouts/maxw.png"
theme.layout_fullscreen = awful.util.getdir("config") .. "/theme/layouts/fullscreenw.png"
theme.layout_tilebottom = awful.util.getdir("config") .. "/theme/layouts/tilebottomw.png"
theme.layout_tileleft   = awful.util.getdir("config") .. "/theme/layouts/tileleftw.png"
theme.layout_tile = awful.util.getdir("config") .. "/theme/layouts/tilew.png"
theme.layout_tiletop = awful.util.getdir("config") .. "/theme/layouts/tiletopw.png"
theme.layout_spiral  = awful.util.getdir("config") .. "/theme/layouts/spiralw.png"
theme.layout_dwindle = awful.util.getdir("config") .. "/theme/layouts/dwindlew.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
