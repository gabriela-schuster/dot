from typing import List  # noqa: F401
import os
import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy

mod = "mod4"
home = os.path.expanduser('~')

terminal = "alacritty"
browser = "firefox"
launcher = "rofi -show drun -disable-history -show-icons -icon-theme 'Tela black'"
filemanager = "pcmanfm"
sshot = "flameshot gui"
vscode = "code"

@hook.subscribe.startup
def autostart():
	home = os.path.expanduser('~/.config/qtile/autostart.sh')
	subprocess.call([home])

#--------- Keybindings ----------------------------------------------

keys = [

	#--------- volume / brightness

	Key([], "XF86AudioRaiseVolume",lazy.spawn("./.config/qtile/eww_vol.sh up"),),
	Key([], "XF86AudioLowerVolume",lazy.spawn("./.config/qtile/eww_vol.sh down"),),
	Key([], "XF86MonBrightnessUp",lazy.spawn("./.config/qtile/brightness.sh + eDP1"),),
	Key([], "XF86MonBrightnessDown",lazy.spawn("./.config/qtile/brightness.sh - eDP1"),),

	#--------- cust Keybindings

	Key([mod], "t", lazy.spawn(terminal),),
	Key([mod], "b", lazy.spawn(browser),),
	Key([mod], "d", lazy.spawn(launcher),),
	Key([mod], "u", lazy.spawn(filemanager),),
	Key([mod], "s", lazy.spawn(sshot),),
	Key([mod], "v", lazy.spawn(vscode),),

	#--------- move / focus

	Key([mod], "k", lazy.layout.down(),),
	Key([mod], "j", lazy.layout.up(),),
	Key([mod], "space",lazy.layout.next(),),
	Key([mod, "shift"], "k", lazy.layout.shuffle_down(),),
	Key([mod, "shift"], "j",lazy.layout.shuffle_up(),),
	Key([mod, "shift"], "space",lazy.layout.rotate(),), 	    # Swap panes of split stack
	# Toggle between split and unsplit sides of stack.
	# Split = all windows displayed
	# Unsplit = 1 window displayed, like Max layout, but still with
	# multiple stack panes
	Key([mod, "shift"], "Return",lazy.layout.toggle_split(),),


	#--------- layouts

	#MonadTall
	Key([mod], "h",lazy.layout.grow(), lazy.layout.increase_nmaster(),),
	Key([mod], "l",lazy.layout.shrink(), lazy.layout.decrease_nmaster(),),

	#Change
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
		lazy.window.kill(),desc="Kill focused window"),
	Key([mod, "shift"], "r",
		lazy.restart(),desc="Restart qtile"),
	Key([mod], "q",
		lazy.shutdown(),desc="Shutdown qtile"),
	Key([mod], "r",
		lazy.spawncmd(),desc="Spawn a command using a prompt widget"),
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

#--------- Colors --------------------------------------------------------------

colors = [
	["#2c2c2b", "#2c2c2b"],  # background, 0
	["#d5c4a1", "#d5c4a1"],  # foreground, 1
	["#ea6962", "#ea6962"],  # red, 2
	["#e78a41", "#e78a41"],  # yellow, 4
	["#7daea3", "#7daea3"],  # blue, 6
	["#89b482", "#89b482"],  # cyan, 5
	["#a9b665", "#a9b665"],  # green, 3
	["#d3869b", "#d3869b"],  # magenta, 7
	["#d4b398", "#d4be98"],  # white, 8
	["#202020", "#202020"],
]

#--------- Layouts -------------------------------------------------------------

layout_theme = {
	"border_width": 2,
	"margin": 6,
	"border_focus": "#d5c4a1",
	"border_normal": "#2c2c2b"
}

layouts = [
	#layout.MonadWide(**layout_theme),
	#layout.Bsp(**layout_theme),
	#layout.Columns(**layout_theme),
	#layout.RatioTile(**layout_theme),
	#layout.VerticalTile(**layout_theme),
	#layout.Matrix(**layout_theme),
	#layout.Stack(num_stacks=2, **layout_theme),
	#layout.Tile(**layout_theme),
	#layout.Zoomy(**layout_theme,
	#columnwidth = 150),
	# layout.TreeTab(**layout_theme,
	# font = "Sf Mono",
	# fontsize = 14,
	# sections = ["... to move up/down"],
	# section_fontsize = 11,
	# bg_color = "202020",
	# active_bg = colors[5],
	# active_fg = colors[0],
	# inactive_bg = colors[0],
	# inactive_fg = colors[1],
	# padding_y = 5,
	# section_top = 10,
	# panel_width = 220
	# ),
	layout.MonadTall(**layout_theme),
	layout.Max(),
	layout.Floating(**layout_theme),
]

widget_defaults = dict(
	font='Scientifica Bold',
	fontsize= 18,
	padding=5,
)
extension_defaults = widget_defaults.copy()

#--------- functions ----------------------------------------------------------

def open_wifi_config():
	lazy.spawn('nm-connection-editor')

def shut():
	lazy.spawncmd('shutdown now')

#--------- Bar ----------------------------------------------------------------

dark_sep = {'linewidth': 3, 'size_percent': 100,
            'background': '#2c2c2b', 'foreground': '#2c2c2b', 
			'padding': 5}


screens = [
	Screen(
		top=bar.Bar(
			[
				widget.GroupBox(
					disable_drag = True,
					hide_unused = False,
					font = "Scientifica",
					margin_y = 4,
					margin_x = 5,
					padding_y = 5,
					padding_x = 3,
					borderwidht = 3,
					center_aligned = True,
					background = colors[0],
					active = colors[7],
					inactive = colors[1],
					block_highlight_text_color = colors[0],	#selected foregroud
					this_current_screen_border = colors[7],
					this_screen_border = colors[0],         # when no window is focused
					urgent_border = colors[2],
					highlight_color = colors[0],
					highlight_method = 'block',
				),
				widget.Sep(**dark_sep),
				widget.CurrentLayout(
					#custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
					foreground = colors[0],
					background = colors[7],
					padding = 5,
					scale = 0.7
				),
				widget.Prompt(
					padding = 10,
					foreground = colors[1],
					background = colors[0]
				),
				widget.Sep(**dark_sep),
				# widget.Spacer(
				# 	background = colors[0]
				# ),
				widget.TextBox(
					text="",
					foreground = colors[1],
					background = colors[0],
					font = 'font awesome'
				),
				widget.WindowName(
					foreground = colors[1],
					background = colors[0],
					padding = 5,
		 		   	empty_group_string = 'Desktop',
		   			max_chars = 100,
					# width=bar.CALCULATED, uncomment this and the two spacers to push all things to the left/right and make the window name centralized
		   			format = '{state}{name}'
				),
				# widget.Spacer(
				# 	background = colors[0]
				# ),
				widget.TextBox(
					text="",
					foreground=colors[0],
					background=colors[7],
					fontsize = 15,
					font = 'font awesome'
				),
				widget.Wlan(
					interface = 'wlp1s0',
					format = "{essid}",
					foreground = colors[0],
					background = colors[7],
					padding = 5,
					disconnected_message = 'Offline',
					update_interval = 1,
					mouse_callbacks = {'Button1': open_wifi_config}
				),
				# widget.Net(
				#     format = '{down} ↓↑ {up}',
				#     foreground = colors[0],
				#     background = colors[7],
				# 	padding = 5
				# ),
				widget.Sep(**dark_sep),
				widget.TextBox(
					text="",
					foreground=colors[0],
					background=colors[1],
					fontsize = 15,
					font = 'font awesome'
				),
				widget.Volume(
					foreground=colors[0],
					background=colors[1],
					limit_max_volume="True",
				),
				widget.Sep(**dark_sep),
				 widget.TextBox(
					text="",
					foreground=colors[0],
					background=colors[7],
					fontsize = 15,
					font = 'font awesome'
				),
				widget.Battery(
					foreground = colors[0],
					background = colors[7],
					battery = 0,
					charge_char = "»",
					discharge_char = "«",
					full_char = "º",
					notify_below = 15,
					low_foreground = colors[2],
					format = '{char}{percent:2.0%}'
				),
				widget.Sep(**dark_sep),
				widget.TextBox(
					text='',
					foreground=colors[0],
					background=colors[1],
					fontsize = 15,
					font = 'font awesome'
				),
				widget.CPU(
					background = colors[1],
					foreground = colors[0],
					format = '{load_percent}%',
					update_interval = 2.0,
				),
				widget.TextBox(
					text='',
					foreground=colors[0],
					background=colors[1],
					fontsize = 15,
					font = 'font awesome'
				),
				widget.Memory(
					background = colors[1],
					foreground = colors[0],
					format = '{MemUsed}Mb'
				),
				widget.Sep(**dark_sep),
				widget.TextBox(
					text = '',
					background=colors[7],
					foreground=colors[0],
					font = 'font awesome',
					fontsize = 15
				),
				widget.Clock(
					foreground = colors[0],
					background = colors[7],
					format = "%a, %b %d [ %H:%M ]",
				),
				widget.Sep(**dark_sep),
				widget.Systray(
					background = colors[0],
					padding = 5,
				),
				widget.TextBox(
					text="⏻",
					background = colors[1],
					foreground = colors[0],
					fontsize = 15,
					padding = 5,
					mouse_callbacks = {'Button1': shut},
					font = 'font awesome'
				),
			],
		size = 20,
		margin = 3,
		opacity = 0.9,),
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
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[		# what class should always be floating
	# Run the utility of `xprop` to see the wm class and name of an X client.
	*layout.Floating.default_float_rules,
])
auto_fullscreen = True
focus_on_window_activation = "mouse"

# @hook.subscribe.startup_once
# def start_once():
#     home = os.path.expanduser('~')
#     subprocess.call([home + '/.config/qtile/autostart.sh'])

wmname = "LG3D"
