######################################################################
#<
#
# Function: p6df_usage([rc=0], [msg=])
#
#  Args:
#	OPTIONAL rc - [0]
#	OPTIONAL msg - []
#
#  Environment:	 EOF
#>
#/ Synopsis
#/    bin/p6df [-D|-d] [cmd]
#/
######################################################################
p6df_usage() {
  local rc="${1:-0}"
  local msg="${2:-}"

  if [ -n "$msg" ]; then
    p6_msg "$msg"
  fi
  cat <<EOF
Usage: bin/p6df [-D|-d] [cmd]

Options:
  -D    debeug off
  -d	debug on

Cmds:
  help
  doc
  module update
  module fetch
EOF

  exit "$rc"
}

######################################################################
#<
#
# Function: p6_function_p6df(...)
#
#  Args:
#	... -
#
#  Environment:	 LC_ALL OPTIND
#>
#/ Synopsis
#/    bin/p6df [-D|-d] [cmd]
#/
#/ Synopsis
#/    The entry point for bin/p6df
#/
######################################################################
p6_function_p6df() {
  shift 0

  # sanitize env
  LC_ALL=C

  # default options
  local flag_debug=0

  # parse options
  local flag
  while getopts "dD" flag; do
    case $flag in
    D) flag_debug=0 ;;
    d) flag_debug=1 ;;
    *) p6df_usage 1 "invalid flag" ;;
    esac
  done
  shift $((OPTIND - 1))

  # grab command
  local cmd="$1"
  shift 1

  # security 101: only allow valid comamnds
  case $cmd in
  help) p6df_usage ;;
  doc) ;;
  module) ;;
  *) p6df_usage 1 "invalid cmd" ;;
  esac

  # setup -x based on flag_debug
  [ ${flag_debug} = 1 ] && set -x

  # exit if any cli errors w/ >0 return code
  # the commands can still disable locally if needed
  set -e
  p6_msg "$cmd"
  p6_cmd_df_"${cmd}" "$@"
  p6_msg_success "$cmd"
  set +e

  # stop debugging if it was enabled
  [ ${flag_debug} = 1 ] && set +x

  return 0
}
######################################################################
#<
#
# Function: p6_cmd_df_doc()
#
#>
######################################################################
p6_cmd_df_doc() {

  p6df::core::module::use "p6m7g8-dotfiles/p6df-perl"
  p6_cicd_doc_gen
}

######################################################################
#<
#
# Function: p6_cmd_df_module(sub_cmd, module)
#
#  Args:
#	sub_cmd -
#	module -
#
#>
######################################################################
p6_cmd_df_module() {
  local sub_cmd="$1"
  local module="$2"

  p6df::core::module::use "p6m7g8-dotfiles/p6git"

  (
    set +e
    p6_cmd_df_module_"${sub_cmd}" "$module"
  )
}

######################################################################
#<
#
# Function: p6_cmd_df_module_use(module)
#
#  Args:
#	module -
#
#>
######################################################################
p6_cmd_df_module_use() {
  local module="$1"

  p6df::core::module::use "$module"
}

######################################################################
#<
#
# Function: p6_cmd_df_module_fetch(module)
#
#  Args:
#	module -
#
#>
######################################################################
p6_cmd_df_module_fetch() {
  local module="$1"

  p6df::core::module::fetch "$module"
}

######################################################################
#<
#
# Function: p6_cmd_df_module_update(module)
#
#  Args:
#	module -
#
#>
######################################################################
p6_cmd_df_module_update() {
  local module="$1"

  p6df::core::module::update "$module"
}

######################################################################
#<
#
# Function: p6_cmd_df_module_vscodes(module)
#
#  Args:
#	module -
#
#>
######################################################################
p6_cmd_df_module_vscodes() {
  local module="$1"

  p6df::core::module::vscodes "$module"
}

######################################################################
#<
#
# Function: p6_cmd_df_module_langs(module)
#
#  Args:
#	module -
#
#>
######################################################################
p6_cmd_df_module_langs() {
  local module="$1"

  p6df::core::module::use "$module"
  p6df::core::module::langs "$module"
}
