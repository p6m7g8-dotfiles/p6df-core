######################################################################
#<
#
# Function: p6df::core::aliases::init()
#
#>
######################################################################
p6df::core::aliases::init() {

  alias p6df_i="p6df::core::init"

  alias p6df_md="p6df -a diff"
  alias p6df_mp="p6df -a pull"
  alias p6df_mP="p6df -a push"
  alias p6df_mS="p6df -a sync"
  alias p6df_ms="p6df -a status"
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
