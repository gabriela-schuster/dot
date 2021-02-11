from typing import List  # noqa: F401
import os
import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy

mod = "mod4"
terminal = "kitty"
browser = "firefox"
launcher = "rofi -show drun -disable-history -show-icons -icon-theme 'Luna Dark'"
caja = "caja"

@hook.subscribe.startup
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])

#--------- Keybindings ----------------------------------------------

keys = [
    # Switch window focus to other pane(s) of stack
    Key([mod], "space",
        lazy.layout.next(),
        desc="Switch window focus to other pane(s) of stack"
        ),

    # Swap panes of split stack
    Key([mod, "shift"], "space",
        lazy.layout.rotate(),
        desc="Swap panes of split stack"
        ),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"
        ),
    #--------- volume / brightness TODO
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("./.config/qtile/eww_vol.sh up"),
        desc="Increase volume",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("./.config/qtile/eww_vol.sh down"),
        desc="Decrease volume",
    ),

    #--------- cust Keybindings
    Key([mod], "t",
        lazy.spawn(terminal), 
        desc="Launch terminal"
        ),
    Key([mod], "b", 
        lazy.spawn(browser), 
        desc="Launch browser"
        ),
    Key([mod], "d", 
        lazy.spawn(launcher), 
        desc="Launch rofi"
        ),
    Key([mod, "shift"], "f",
        lazy.spawn(caja),
        desc="Launch caja"
        ),

    #--------- windows

    # move / focus
    Key([mod], "k",
        lazy.layout.down(),
        desc="Move focus down in stack pane"
        ),
    Key([mod], "j",
        lazy.layout.up(),
        desc="Move focus up in stack pane"
        ),
    Key([mod, "shift"], "k",
        lazy.layout.shuffle_down(),
        desc="Move window down in current stack "
        ),
    Key([mod, "shift"], "j",
        lazy.layout.shuffle_up(),
        desc="Move window up in current stack "
        ),
    Key([mod], "h",
        lazy.layout.grow(),
        lazy.layout.increase_nmaster(),
        desc='Expand window (MonadTall), increase number in master pane(Tile)'
        ),
    Key([mod], "l",
        lazy.layout.shrink(),
        lazy.layout.decrease_nmaster(),
        desc='Shrink window (MonadTall), decrease number in master pane(Tile)'
        ),

    # layouts
    Key([mod], "f",
        lazy.window.toggle_floating(),
        desc='toggle floating'
        ),
    Key([mod], "n",
        lazy.layout.normalize(),
        desc='normalize window size ratios'
        ),
    Key([mod], "Tab",
        lazy.next_layout(), 
        desc="Toggle between layouts"
        ),

    #--------- Sys key
    Key([mod], "c",
        lazy.window.kill(), 
        desc="Kill focused window"
        ),
    Key([mod, "shift"], "r",
        lazy.restart(), 
        desc="Restart qtile"
        ),
    Key([mod, "shift"], "q",
        lazy.shutdown(), 
        desc="Shutdown qtile"
        ),
    Key([mod], "r", 
        lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"
        ),
]

#--------- Workspaces -----------------------------------------------

groups = [Group(i) for i in "123456"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

#--------- Colors -----------------------------------------

colors = [
    ["#141414", "#141414"],  # background, 0
    ["#bcbcbc", "#bcbcbc"],  # foreground, 1
    ["#ea6962", "#ea6962"],  # red, 2
    ["#a9b665", "#a9b665"],  # green, 3
    ["#e78a41", "#e78a41"],  # yellow, 4
    ["#5f8787", "#5f8787"],  # blue, 5
    ["#d3869b", "#d3869b"],  # magenta, 6
    ["#89b482", "#89b482"],  # cyan, 7
    ["#d4b398", "#d4be98"],  # white, 8
    ["#4c566a", "#4c566a"],  # grey, 9
    ["#d08770", "#d08770"],  # orange, 10
]

#--------- Layouts --------------------------------------------------

layout_theme = {
    "border_width": 2,
    "margin": 6,
    "border_focus": "5f8787",
    "border_normal": "121212"
}

layouts = [
    #layout.MonadWide(**layout_theme),
    #layout.Bsp(**layout_theme),
    #layout.Stack(stacks=2, **layout_theme),
    #layout.Columns(**layout_theme),
    #layout.RatioTile(**layout_theme),
    #layout.VerticalTile(**layout_theme),
    #layout.Matrix(**layout_theme),
    #layout.Zoomy(**layout_theme),
    #layout.TreeTab(**layout_theme)
    #layout.Stack(num_stacks=2, **layout_theme),
    layout.MonadTall(**layout_theme),
    layout.Max(),
    #layout.Tile(**layout_theme),
    layout.Floating(**layout_theme)
]

widget_defaults = dict(
    font='Scientifica bold',
    fontsize= 18,
    padding=3,
)
extension_defaults = widget_defaults.copy()

#--------- Functions --------------------------------------
#--------- Mouse_callback
def open_launcher():
    qtile.cmd_spawn("./.config/rofi/launchers/ribbon/launcher.sh")


def finish_task():
    qtile.cmd_spawn('task "$((`cat /tmp/tw_polybar_id`))" done')


def kill_window():
    qtile.cmd_spawn("xdotool getwindowfocus windowkill")

def open_pavu():
    qtile.cmd_spawn("pavucontrol")


#--------- Bar --------------------------------------------

screens = [
    Screen(
        top=bar.Bar(
            [
                #widget.Image(
                #    filename = "~/.config/qtile/icons/python.png",
                #    mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn('dmenu_run')}
                #),
                widget.GroupBox(
                    font = "Scientifica",
                    background = colors[0],
                    active = colors[1],
                    inactive = colors[1],
                    margin_y = 4,
                    margin_x = 5,
                    padding_y = 5,
                    padding_x = 3,
                    borderwidht = 3,
                    this_current_screen_border = colors[5],
                    this_screen_border = colors[0],         # when no window is focused
                    hide_unused = False,
                    highlight_color = colors[0],
                    highlight_method = 'line',
                ),
                widget.CurrentLayoutIcon(
                    #custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
                    foreground = colors[1],
                    background = colors[0],
                    padding = 5,
                    scale = 0.7
                ),
                #widget.Spacer(),
                widget.WindowName(
                    foreground = colors[1],
                    background = colors[0],
                    padding = 30
                ),

                widget.TextBox(
                    text="",
                    foreground=colors[0],
                    background=colors[0],
                    fontsize=40,
                    padding=0,
                ),
                widget.PulseVolume(
                    foreground=colors[1],
                    background=colors[0],
                    limit_max_volume="True",
                    mouse_callbacks={"Button3": open_pavu},
                ),
                #widget.Backlight(),
                widget.TextBox(
                    text = '|',
                    background = colors[0],
                    foreground = colors[5],
                    padding = 0,
                    fontsize = 30
                ),
                widget.Battery(
                    foreground = colors[1],
                    background = colors[0],
                    battery = 0,
                    charge_char = "»",
                    discharge_char = "«",
                    full_char = "º",
                    low_foreground = colors[2],
                    format = '{char}{percent:2.0%}'
                ),
                widget.TextBox(
                    text = '|',
                    background = colors[0],
                    foreground = colors[5],
                    padding = 0,
                    fontsize = 30
                ),
                widget.Clock(
                    foreground = colors[1],
                    background = colors[0],
                    format = "%a, %b %d [ %H:%M ]"
                ),
                
                widget.Systray(     #if discord is open in plane
                    background = colors[0],
                    padding = 5,
                ),
                widget.TextBox(
                    text="",
                    foreground=colors[0],
                    background=colors[0],
                    fontsize=10,
                    padding=0,
                ),
            ],
            opacity = 0.9,
            size = 20,
            background = "#2b2b2c",
            foreground = "#d5c4a1",
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
