# shellcheck shell=bash

######################################################################
#<
#
# Function: p6df::core::env::module::init(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::env::module::init() {
  local module="$1"
  local dir="$2"

  # %repo
  p6df::core::module::parse "$module"
  local env_func=$repo[env_init]
  unset repo

  if type -f "$env_func" >/dev/null 2>&1; then
    p6_run_yield "$env_func $module $dir"
  fi

  p6_return_void
}
