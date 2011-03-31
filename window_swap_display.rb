#!/usr/bin/env ruby

XWI='/usr/bin/xwininfo'
XPROP='/usr/bin/xprop'
XDT='/usr/bin/xdotool'
NVD='/usr/bin/nvidia-xconfig'
$sw = nil

def screen_width
  unless $sw
    output=`#{NVD} -t`
    $sw = output.slice(/^.*metamodes.*/).split('DFP-1').last.split('+')[1].to_i
  end
  $sw
end

def current_window_position
  output = `#{XPROP} -root`
  id = output.slice(/^.*_NET_ACTIVE_WINDOW\(WINDOW\).*/).split(' ').last
  output = `#{XWI} -id #{id}`
  x = output.slice(/^.*Absolute upper-left X.*/).split(' ').last.to_i
  y = output.slice(/^.*Absolute upper-left Y.*/).split(' ').last.to_i
  return x,y
end

x,y = current_window_position

if x < screen_width
  x += screen_width
else
  x -= screen_width
end

window=`#{XDT} getwindowfocus`.chomp
`#{XDT} windowmove #{window} #{x} #{y}`
`#{XDT} windowfocus #{window}`
`#{XDT} windowraise #{window}`

exit 0
