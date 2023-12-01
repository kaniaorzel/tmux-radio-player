#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


BLUETOOTH_MAC=""

get_settings() {
   BLUETOOTH_MAC=$(get_tmux_option "@radio_player_bluetooth_mac" "")
}

get_tmux_option() {
  local option
  local default_value
  local option_value
  option="$1"
  default_value="$2"
  option_value="$(tmux show-option -qv "$option")"
  if [ -z "$option_value" ]; then
    option_value="$(tmux show-option -gqv "$option")"
  fi
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}


set_tmux_option() {
  local option=$1
  local value=$2
  tmux set-option -gq "$option" "$value"
}

do_interpolation() {
  local all_interpolated="$1"
  for ((i = 0; i < ${#cpu_commands[@]}; i++)); do
    all_interpolated=${all_interpolated//${cpu_interpolation[$i]}/${cpu_commands[$i]}}
  done
  echo "$all_interpolated"
}

update_tmux_option() {
  local option
  local option_value
  local new_option_value
  option=$1
  option_value=$(get_tmux_option "$option")
  new_option_value=$(do_interpolation "$option_value")
  set_tmux_option "$option" "$new_option_value"
}


main() {
  get_settings
  tmux bind-key r run-shell "$CURRENT_DIR/scripts/bluetooth_reconnect"

}
main
