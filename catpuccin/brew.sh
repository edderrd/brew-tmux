show_brew() {
  local index icon color text module cask_icon formulae_icon separator check_seconds

  add_tmux_batch_option "@catppuccin_brew_cask_icon"
  add_tmux_batch_option "@catppuccin_brew_formulae_icon"
  add_tmux_batch_option "@catppuccin_brew_separator"
  add_tmux_batch_option "@catppuccin_brew_check_seconds"

  run_tmux_batch_commands

  index=$1
  icon="$(get_tmux_option "@catppuccin_brew_icon" "󱉙")"
  cask_icon=$(get_tmux_batch_option "@catppuccin_brew_cask_icon" "")
  formulae_icon=$(get_tmux_batch_option "@catppuccin_brew_formulae_icon" "")
  separator=$(get_tmux_batch_option "@catppuccin_brew_separator" "  ")
  check_seconds=$(get_tmux_batch_option "@catppuccin_brew_check_seconds" "3600")
  color="$(get_tmux_option "@catppuccin_brew_color" "$thm_orange")"
  text="$(get_tmux_option "@catppuccin_brew_text" "#(BREW_TMUX_CASK_ICON=$cask_icon BREW_TMUX_FORMULAE_ICON=$formulae_icon BREW_TMUX_SEPARATOR='$separator' BREW_TMUX_CHECK_SECONDS=$check_seconds \${TMUX_PLUGIN_MANAGER_PATH}/brew-tmux/brew.tmux)")"

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
