-- Its own wibox
-- Visible/hidden
-- Add notifications
-- Make it configurable?

local wibox = require("wibox")
local awful = require("awful")
local timer = timer
local string = string

local Pomodoro = {
  iteration = 1,
  widget = wibox.widget.textbox(),
  wibox = wibox({ x = 200, y = 200, ontop = true}),
  timer = timer({ timeout = 1 }),
  time_left = 0
}

function Pomodoro:reset_timer()
  if self.iteration % 4 == 0 then
    self.time_left = 900
  elseif self.iteration % 2 == 0 then
    self.time_left = 300
  else
    self.time_left = 1500
  end
end

function Pomodoro:decrease_timer()
  self.time_left = self.time_left - 1
  if self.time_left == 0 then
    self.iteration = self.iteration + 1
    self.time_left = self:reset_timer()
  end
  self.widget:set_text(self:widget_text())
end

function Pomodoro:notify()
  -- naughty
  -- play sound
end

function Pomodoro:status()
  if self.iteration % 2 == 0 then
    return "Rest"
  else
    return "Work"
  end
end

function Pomodoro:widget_text()
  local minutes = self.time_left / 60
  local seconds = self.time_left % 60
  local current_status = self:status()
  return string.format(" %s %02d:%02d ", current_status, minutes, seconds)
end

pomodoro = Pomodoro

pomodoro.wibox.ontop = true
pomodoro.wibox:geometry({ width=100, height=200, x=400,y=200})
pomodoro.wibox.screen = 1
pomodoro.wibox:set_widget(pomodoro.widget)
pomodoro:reset_timer()
pomodoro.widget:set_text(pomodoro:widget_text())
pomodoro.timer:connect_signal("timeout", function() pomodoro:decrease_timer() end)
pomodoro.timer:start()


return pomodoro

