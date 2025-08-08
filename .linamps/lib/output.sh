
# --- COLORED OUTPUT --- #
function cecho() {
  local color_text text style=""
  local bold=0 italic=0

  # Map of supported colors
  declare -A color_map=(
    [black]=30 [red]=31 [green]=32 [yellow]=33
    [blue]=34 [magenta]=35 [cyan]=36 [white]=37
    [bright_black]=90 [bright_red]=91 [bright_green]=92 [bright_yellow]=93
    [bright_blue]=94 [bright_magenta]=95 [bright_cyan]=96 [bright_white]=97
  )

  # Must have at least one argument
  if [[ $# -lt 2 ]]; then
    echo "Usage: cecho <color> [--bold] [--italic] <text...>"
    return 1
  fi

  # First argument is the color
  color_text="${1,,}" # force lowercase
  shift

  # Parse optional flags
  while [[ "$1" == --* ]]; do
    case "$1" in
      --bold) bold=1 ;;
      --italic) italic=1 ;;
      *) echo "Unknown flag: $1" && return 1 ;;
    esac
    shift
  done

  # Remaining args form the text
  text="$*"

  # Get ANSI color code
  local color_code="${color_map[$color_text]}"
  if [[ -z "$color_code" ]]; then
    echo "Invalid color: $color_text"
    return 1
  fi

  # Build the style
  [[ $bold -eq 1 ]] && style+="1;"
  [[ $italic -eq 1 ]] && style+="3;"
  style+="$color_code"

  # Output the formatted text
  echo -e "\e[${style}m${text}\e[0m"
}
