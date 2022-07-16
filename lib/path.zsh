######################################################################
#<
#
# Function: p6df::core::path::if(dir)
#
#  Args:
#	dir -
#
#>
######################################################################
p6df::core::path::if() {
  local dir="$1"

  if [[ -d "$dir" ]]; then
    path+=($dir)
  fi
}

######################################################################
#<
#
# Function: p6df::core::path::cd::if(dir)
#
#  Args:
#	dir -
#
#>
######################################################################
p6df::core::path::cd::if() {
  local dir="$1"

  if [[ -d "$dir" ]]; then
    cdpath+=($dir)
  fi
}

######################################################################
#<
#
# Function: p6df::core::path::init()
#
#  Environment:	 X11
#>
######################################################################
p6df::core::path::init() {
  local dir="$1"

  path=()
  path+=($dir/bin)
  path+=($dir/../p6common/bin)
  p6df::core::path::if /opt/X11/bin
  p6df::core::path::if /usr/local/bin
  p6df::core::path::if /usr/local/sbin
  p6df::core::path::if /usr/bin
  p6df::core::path::if /usr/sbin
  p6df::core::path::if /bin
  p6df::core::path::if /sbin
}

######################################################################
#<
#
# Function: p6df::core::path::cd::init()
#
#  Environment:	 P6_DFZ_SRC_DIR P6_DFZ_SRC_FOCUSED_DIR P6_DFZ_SRC_GH_DIR P6_DFZ_SRC_P6M7G8_AUTOMATION_DIR P6_DFZ_SRC_P6M7G8_DIR P6_DFZ_SRC_P6M7G8_DOTFILES_DIR P6_DFZ_SRC_WORK_CAREREV_DIR P6_DFZ_SRC_WORK_DIR
#>
######################################################################
p6df::core::path::cd::init() {

  cdpath=()
  p6df::core::path::cd::if $P6_DFZ_SRC_GH_DIR
  p6df::core::path::cd::if $P6_DFZ_SRC_DIR
  p6df::core::path::cd::if $P6_DFZ_SRC_P6M7G8_DIR
  p6df::core::path::cd::if $P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
  p6df::core::path::cd::if $P6_DFZ_SRC_P6M7G8_AUTOMATION_DIR
  p6df::core::path::cd::if $P6_DFZ_SRC_FOCUSED_DIR
  p6df::core::path::cd::if $P6_DFZ_SRC_WORK_DIR
  p6df::core::path::cd::if $P6_DFZ_SRC_WORK_CAREREV_DIR
}
