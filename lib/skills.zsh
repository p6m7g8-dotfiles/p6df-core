######################################################################
#<
#
# Function: p6df::core::skills::module::init(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::skills::module::init() {
  local module="$1"
  local dir="$2"

  # %repo
  p6df::core::module::parse "$module"
  local skills_func=$repo[skills_init]
  unset repo

  if type -f "$skills_func" >/dev/null 2>&1; then
    p6_run_yield "$skills_func $module $dir"
  fi

  p6_return_void
}
