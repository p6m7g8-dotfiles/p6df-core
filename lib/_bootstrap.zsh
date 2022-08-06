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

. $P6_DFZ_LIB_DIR/_bootstrap.zsh
. $P6_DFZ_LIB_DIR/aliases.zsh
. $P6_DFZ_LIB_DIR/cli.zsh
. $P6_DFZ_LIB_DIR/dev.zsh
. $P6_DFZ_LIB_DIR/file.zsh
. $P6_DFZ_LIB_DIR/internal.zsh
. $P6_DFZ_LIB_DIR/main.zsh
. $P6_DFZ_LIB_DIR/module.zsh
. $P6_DFZ_LIB_DIR/modules.zsh
. $P6_DFZ_LIB_DIR/path.zsh
. $P6_DFZ_LIB_DIR/prompt.zsh
. $P6_DFZ_LIB_DIR/theme.zsh
. $P6_DFZ_LIB_DIR/user.zsh

  p6df::core::modules::bootstrap::p6common
}
