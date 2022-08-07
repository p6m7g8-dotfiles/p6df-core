# shellcheck shell=bash

######################################################################
#<
#
# Function: p6df::core::_bootstrap()
#
#  Environment:	 P6_DFZ_LIB_DIR
#>
######################################################################
p6df::core::_bootstrap() {

  . $P6_DFZ_LIB_DIR/main.zsh

  p6df::core::main::self::init
}
