######################################################################
#<
#
# Function: p6df::core::aliases::init()
#
#>
######################################################################
p6df::core::aliases::init() {

  p6_alias "p6df_i" "p6df::core::init"

  p6_alias "p6df_md" "p6df -a diff"
  p6_alias "p6df_mp" "p6df -a pull"
  p6_alias "p6df_mP" "p6df -a push"
  p6_alias "p6df_mS" "p6df -a sync"
  p6_alias "p6df_ms" "p6df -a status"

  # Homebrew aliases
  p6df::core::homebrew::aliases::init
}

######################################################################
#<
#
# Function: p6df::core::aliases::module::init(module)
#
#  Args:
#	module -
#
#>
######################################################################
p6df::core::aliases::module::init() {
  local module="$1"

  # %repo
  p6df::core::module::parse "$module"
  local alias_func=$repo[alias]
  unset repo

  if type -f "$alias_func" >/dev/null 2>&1; then
    p6_run_yield "$alias_func"
  fi

  p6_return_void
}
