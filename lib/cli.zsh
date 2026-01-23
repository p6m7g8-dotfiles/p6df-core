######################################################################
#<
#
# Function: p6df::core::cli::usage([rc=0], [msg=])
#
#  Args:
#	OPTIONAL rc - [0]
#	OPTIONAL msg - []
#
#  Environment:	 P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
#/ Synopsis
#/    bin/p6df [-D|-d] [cmd]
#/
######################################################################
p6df::core::cli::usage() {
  local rc="${1:-0}"
  local msg="${2:-}"

  if [ -n "$msg" ]; then
    p6_msg "$msg"
  fi
  cat <<EOF
Usage: bin/p6df [-D|-d] [-a] [cmd]

Options:
  -a  ALL modules
  -D  debeug off
  -d  debug on

Cmds:
  help
EOF

  grep ^p6df $P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-core/lib/module.zsh | sed -e 's,.*::,  ,' -e 's,(.*,,' | sort

  exit "$rc"
}

######################################################################
#<
#
# Function: p6df::core::cli::run(...)
#
#  Args:
#	... - 
#
#>
######################################################################
p6df::core::cli::run() {
  shift 0

  # sanitize env
  LC_ALL=C

  # default options
  local flag_debug=0
  local flag_all=0
  local flag_bootstrap=0

  # parse options
  local flag
  while getopts "abdD" flag; do
    case $flag in
    a) flag_all=1 ;;
    b) flag_bootstrap=1 ;;
    D) flag_debug=0 ;;
    d) flag_debug=1 ;;
    *) p6df::core::cli::usage 1 "invalid flag" ;;
    esac
  done
  shift $((OPTIND - 1))

  # grab command
  local cmd="$1"
  shift 1

  local dir=$(pwd)

  local module="$1"
  if p6_string_blank "$module"; then
    module=$(p6df::core::module::expand $(p6_uri_name "$dir"))
  else
    shift 1
  fi

  # setup -x based on flag_debug
  [ ${flag_debug} = 1 ] && set -x

  # exit if any cli errors w/ >0 return code
  # the commands can still disable locally if needed
  # set -e
  p6_msg "$cmd"

  p6df::core::module::use "p6m7g8-dotfiles/p6git"
  p6df::core::module::use "p6m7g8-dotfiles/p6df-perl"
  p6df::core::module::use "p6m7g8-dotfiles/p6df-zsh"

  if p6_string_eq "$flag_all" "1"; then
    p6df::core::cli::all "$cmd" "$@"
  else
    case $cmd in
    help) p6df::core::cli::usage 0 "" ;;
    p6df::*) p6_run_yield "$cmd" "$module" "$dir" "$@" ;;
    *) p6df::core::module::${cmd} "$module" "$dir" "$@" ;;
    esac
  fi

  p6_msg_success "$cmd"
  # set +e

  # stop debugging if it was enabled
  [ ${flag_debug} = 1 ] && set +x

  return 0
}

######################################################################
#<
#
# Function: p6df::core::cli::all(cmd, ...)
#
#  Args:
#	cmd -
#	... -
#
#  Environment:	 P6_DFZ_MODULES P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::core::cli::all() {
  local cmd="$1"
  shift 1

  local dir

  local modules
  if p6_string_eq_1 "$flag_bootstrap"; then
    modules="$P6_DFZ_MODULES"
  else
    modules=$(p6_dir_list "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR")
  fi
  for dir in $(p6_echo $modules); do
    p6_h1 "$dir"
    p6_run_dir "$dir" "p6df::core::cli::all::run" "$dir" "$cmd"
  done
}

######################################################################
#<
#
# Function: p6df::core::cli::all::run(dir, cmd)
#
#  Args:
#	dir -
#	cmd -
#
#>
######################################################################
p6df::core::cli::all::run() {
  local dir="$1"
  local cmd="$2"

  local module=$(p6df::core::module::expand $(p6_uri_name "$dir"))
  p6_h2 "$module"

  p6df::core::internal::recurse "$module" "$dir" "p6df::core::internal::${cmd}" "$@"
}
