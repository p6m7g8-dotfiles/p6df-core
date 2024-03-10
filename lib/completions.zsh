# shellcheck shell=bash

######################################################################
#<
#
# Function: p6df::core::completions::module::init()
#
#>
######################################################################
p6df::core::completions::module::init() {
  local module="$1"
  local dir="$2"

  # %repo
  p6df::core::module::parse "$module"
  local completions_func=$repo[completion]
  unset repo

  if type -f "$copmletions_func" >/dev/null 2>&1; then
    p6_run_yield "$completions_func"
  fi

  p6_return_void
}
