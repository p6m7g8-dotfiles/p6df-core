######################################################################
#<
#
# Function: p6df::core::aliases::init()
#
#>
######################################################################
p6df::core::aliases::init() {

  p6_alias "p6df_i" "p6df::core::init"

  p6_alias "p6_hbr" "p6df::core::homebrew::remove"
  p6_alias "p6_hbcr" "p6df::core::homebrew::casks::remove"
  p6_alias "p6_hbbr" "p6df::core::homebrew::brews::remove"

  p6_alias "p6df_md" "p6df -a diff"
  p6_alias "p6df_mp" "p6df -a pull"
  p6_alias "p6df_mP" "p6df -a push"
  p6_alias "p6df_mS" "p6df -a sync"
  p6_alias "p6df_ms" "p6df -a status"
}

######################################################################
#<
#
# Function: p6df::core::aliases::module::init(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::aliases::module::init() {
  local module="$1"
  local dir="$2"

  # %repo
  p6df::core::module::parse "$module"
  local alias_func=$repo[alias]
  unset repo

  if type -f "$alias_func" >/dev/null 2>&1; then
    p6_run_yield "$alias_func $module $dir"
  fi

  p6_return_void
}
