#!/usr/bin/env bash
#===============================================================================
#   Author: Florin Cosmin Onciu
#  Created: 2021-31-12
#
# Inspired by / Copy of https://github.com/wfxr/tmux-power
#
# Colors (Ayu Dark)
# colors:
#   # Default colors
#   primary:
#     background: '0x0A0E14'
#     foreground: '0xB3B1AD'

#   # Normal colors
#   normal:
#     black:   '0x01060E'
#     red:     '0xEA6C73'
#     green:   '0x91B362'
#     yellow:  '0xF9AF4F'
#     blue:    '0x53BDFA'
#     magenta: '0xFAE994'
#     cyan:    '0x90E1C6'
#     white:   '0xC7C7C7'

#   # Bright colors
#   bright:
#     black:   '0x686868'
#     red:     '0xF07178'
#     green:   '0xC2D94C'
#     yellow:  '0xFFB454'
#     blue:    '0x59C2FF'
#     magenta: '0xFFEE99'
#     cyan:    '0x95E6CB'
#     white:   '0xFFFFFF'
#===============================================================================

# $1: option
# $2: default value
tmux_get() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

# $1: option
# $2: value
tmux_set() {
    tmux set-option -gq "$1" "$2"
}

# Options
right_arrow_icon=$(tmux_get '@snap_the_power_right_arrow_icon' '')
left_arrow_icon=$(tmux_get '@snap_the_power_left_arrow_icon' '')
upload_speed_icon=$(tmux_get '@snap_the_power_upload_speed_icon' '')
download_speed_icon=$(tmux_get '@snap_the_power_download_speed_icon' '')
session_icon="$(tmux_get '@snap_the_power_session_icon' '')"
user_icon="$(tmux_get '@snap_the_power_user_icon' '')"
time_icon="$(tmux_get '@snap_the_power_time_icon' '')"
date_icon="$(tmux_get '@snap_the_power_date_icon' '')"
show_upload_speed="$(tmux_get @snap_the_power_show_upload_speed false)"
show_download_speed="$(tmux_get @snap_the_power_show_download_speed false)"
show_web_reachable="$(tmux_get @snap_the_power_show_web_reachable false)"
prefix_highlight_pos=$(tmux_get @snap_the_power_prefix_highlight_pos)
time_format=$(tmux_get @snap_the_power_time_format '%T')
date_format=$(tmux_get @snap_the_power_date_format '%F')
# short for Theme-Colour
TC=$(tmux_get '@snap_the_power_theme' 'moon')
case $TC in
    'gold' )
        TC='#ffb86c'
        ;;
    'redwine' )
        TC='#b34a47'
        ;;
    'moon' )
        TC='#00abab'
        ;;
    'forest' )
        TC='#228b22'
        ;;
    'violet' )
        TC='#9370db'
        ;;
    'snow' )
        TC='#fffafa'
        ;;
    'coral' )
        TC='#ff7f50'
        ;;
    'sky' )
        TC='#87ceeb'
        ;;
    'default' ) # Useful when your term changes colour dynamically (e.g. pywal)
        TC='colour3'
        ;;
esac

G01=#080808 #232
G02=#121212 #233
G03=#1c1c1c #234
G04=#262626 #235
G05=#303030 #236
# G06=#3a3a3a #237
G06=#1E232B # derived from ayu primary background
G07=#444444 #238
G08=#4e4e4e #239
G09=#585858 #240
G10=#626262 #241
G11=#6c6c6c #242
G12=#767676 #243

G13=#0A0E14
G14=#B3B1AD
G15=#C7C7C7

FG="$G14"
BG="$G13"

SESSION_BG=#91B362
SESSION_FG=#01060E

DATE_BG=#EA6C73
DATE_FG=#0A0E14

TIME_FG=#53BDFA

# Status options
tmux_set status-interval 1
tmux_set status on

# Basic status bar colors
tmux_set status-fg "$FG"
tmux_set status-bg "$BG"
tmux_set status-attr none

# # tmux-prefix-highlight
# tmux_set @prefix_highlight_fg "$BG"
# tmux_set @prefix_highlight_bg "$FG"
# tmux_set @prefix_highlight_show_copy_mode 'on'
# tmux_set @prefix_highlight_copy_mode_attr "fg=$TC,bg=$BG,bold"
# tmux_set @prefix_highlight_output_prefix "#[fg=$TC]#[bg=$BG]$left_arrow_icon#[bg=$TC]#[fg=$BG]"
# tmux_set @prefix_highlight_output_suffix "#[fg=$TC]#[bg=$BG]$right_arrow_icon"

# set-option -g status-left "\
# #[fg=colour7, bg=colour241]#{?client_prefix,#[bg=colour167],} ❐ #S \
# #[fg=colour241, bg=colour237]#{?client_prefix,#[fg=colour167],}#{?window_zoomed_flag, 🔍,}"

#     
# Left side of status bar
tmux_set status-left-bg "$G04"
tmux_set status-left-fg "$G12"
tmux_set status-left-length 150
user=$(whoami)
SESSION="\
#[fg=$SESSION_FG,bg=$SESSION_BG,nobold] $session_icon #S [#I/#P] \
#[fg=$SESSION_BG,bg=$BG,nobold]$right_arrow_icon"
tmux_set status-left "$SESSION"

# Right side of status bar
tmux_set status-right-bg "$G04"
tmux_set status-right-fg "$G12"
tmux_set status-right-length 150
RS="\
#[fg=$G06,bg=$BG]$left_arrow_icon#[fg=$TIME_FG,bg=$G06] $date_icon $date_format#[fg=$BG,bg=$G06,nobold]$left_arrow_icon\
#[fg=$DATE_BG,bg=$G06]$left_arrow_icon#[fg=$DATE_FG,bg=$DATE_BG] $time_icon $time_format "
tmux_set status-right "$RS"

# Window status
tmux_set window-status-format "#[fg=$BG,bg=$G06]$right_arrow_icon #[fg=$G12,bg=$G06,nobold]#I:#W#F #[fg=$G06,bg=$BG]$right_arrow_icon"
tmux_set window-status-current-format "#[fg=$BG,bg=$TIME_FG]$right_arrow_icon#[fg=$SESSION_FG,bold] #I:#W#F #[fg=$TIME_FG,bg=$BG,nobold]$right_arrow_icon"

# Window separator
tmux_set window-status-separator ""

# Window status alignment
# tmux_set status-justify centre
tmux_set status-justify left

# Current window status
tmux_set window-status-current-status "fg=$TC,bg=$BG"

# Pane border
tmux_set pane-border-style "fg=$G07,bg=default"

# Active pane border
tmux_set pane-active-border-style "fg=$TC,bg=$BG"

# Pane number indicator
tmux_set display-panes-colour "$G07"
tmux_set display-panes-active-colour "$TC"

# Clock mode
tmux_set clock-mode-colour "$TC"
tmux_set clock-mode-style 24

# Message
tmux_set message-style "fg=$TC,bg=$BG"

# Command message
tmux_set message-command-style "fg=$TC,bg=$BG"

# Copy mode highlight
tmux_set mode-style "bg=$TC,fg=$FG"
