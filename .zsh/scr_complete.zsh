function _my_completions() {
  local -a mywords
  read -r -A mywords <<< "$scr_capture"
  compadd -a mywords
}
compdef _my_completions -first-
