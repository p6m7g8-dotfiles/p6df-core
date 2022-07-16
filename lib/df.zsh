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
#/    bin/p6ctl [-D|-d] [cmd]
#/
######################################################################
p6df_usage() {
  local rc="${1:-0}"
  local msg="${2:-}"

  if [ -n "$msg" ]; then
    p6_msg "$msg"
  fi
  cat <<EOF
Usage: bin/p6ctl [-D|-d] [cmd]

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

