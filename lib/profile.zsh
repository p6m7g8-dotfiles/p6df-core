# shellcheck shell=bash

######################################################################
#<
#
# Function: str str = p6df::core::profile::prompt::mod()
#
#  Returns:
#	str - str
#
#  Environment:	 P6_DFZ_PROFILE
#>
######################################################################
p6df::core::profile::prompt::mod() {

  local str
  str="_p6_dfz_profile:  $P6_DFZ_PROFILE"

  p6_return_str "$str"
}
