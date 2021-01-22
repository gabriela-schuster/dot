from typing import List  # noqa: F401

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy

mod = "mod4"
terminal = "kitty"
browser = "firefox"
launcher = "rofi -show drun"
caja = "caja"

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
    Key([mod], "j",
        lazy.layout.down(),
        desc="Move focus down in stack pane"
        ),
    Key([mod], "k",
        lazy.layout.up(),
        desc="Move focus up in stack pane"
        ),
    Key([mod, "shift"], "j",
        lazy.layout.shuffle_down(),
        desc="Move window down in current stack "
        ),
    Key([mod, "shift"], "k",
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
    Key([mod, "control"], "r",
        lazy.restart(), 
        desc="Restart qtile"
        ),
    Key([mod, "control"], "q",
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

#--------- Layouts --------------------------------------------------

layout_theme = {
    "border_width": 1,
    "margin": 4,
    "border_focus": "d5c4a1",
    "border_normal": "2b2b2c"
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
    layout.Max(),
    layout.Stack(num_stacks=2, **layout_theme),
    layout.MonadTall(**layout_theme),
    layout.Tile(**layout_theme),
]

widget_defaults = dict(
    font='Sf Mono',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(
                    active = '#d5c4a1',
                    this_current_screen_border = "#d5c4a1",
                    this_screen_border = "#2b2b2c",         # when no window is focused
                    highlight_color = ['#000000', '#d5c4a1'],
                    highlight_method = 'text',
                ),
                widget.Prompt(),        # prompts for user input
                widget.CurrentLayoutIcon(
                    foreground = "#d5c4a1",
                    background = "#2b2b2c",
                    padding = 0,
                    scale = 0.7
                ),

                widget.WindowName(
                    foreground = "#d5c4a1",
                    background = "#2b2b2c",
                    padding = 0
                ),

                widget.Volume(
                    foreground = "#d5c4a1",
                    background = "#2b2b2c",
                    padding = 5
                ),
                widget.Clock(
                    foreground = "#d5c4a1",
                    background = "#2c2c2b",
                    format = "%A, %B %d  [ %H:%M ]"
                ),
                widget.Systray(
                    background = "#d5c4a1",
                    padding = 5
                ),
                widget.Battery(),
                widget.QuickExit(),
            ],
            24,
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
