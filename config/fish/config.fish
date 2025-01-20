source ~/.asdf/asdf.fish

fish_add_path ~/.config/scripts
set -x XDG_DATA_DIRS "/usr/share"

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Display new line after each command
function postexec_test --on-event fish_postexec
    set -l cols (tput cols)
    set -l line (string repeat -n $cols "─")
    echo -e "\e[90m$line\e[0m"
end

# Functions needed for !! and !$
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

# The bindings for !! and !$
if [ "$fish_key_bindings" = "fish_vi_key_bindings" ];
  bind -Minsert ! __history_previous_command
#   bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
#   bind '$' __history_previous_command_arguments
end

# Easy fish history
alias hist='cat ~/.local/share/fish/fish_history'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# adding flags
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# set fish_greeting
function fish_greeting
	# curl "wttr.in/City?T0Q" --silent --max-time 3
	# curl "wttr.in/Encantado?format=3" --silent --max-time 3
    set_color blue
    echo "   ,_"
	set_color yellow
	echo -n "  >"
    set_color blue
    echo "' )"
    echo "  ( ( \\"
    set_color yellow
    echo -n "  m"
    set_color blue
    echo "'' |\\"
    set_color normal
    echo ""
end
