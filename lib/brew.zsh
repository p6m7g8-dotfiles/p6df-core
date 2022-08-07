# shellcheck shell=bash

######################################################################
#<
#
# Function: p6df::modules::homebrew::init()
#
#  Environment:	 HOMEBREW_EDITOR
#>
#/ Synopsis
#/   Warning: Using vim because no editor was set in the environment.
#/   This may change in the future, so we recommend setting EDITOR,
#/   or HOMEBREW_EDITOR to your preferred text editor.
######################################################################
p6df::core::homebrew::init() {

  local homebrew_prefix=$(brew --config | awk -F: '/PREFIX/ { print $2 }' | sed -e 's, ,,g')

  p6_env_export "HOMEBREW_EDITOR" "vim"
  p6_env_export "HOMEBREW_PREFIX" "$homebrew_prefix"
}

######################################################################
#<
#
# Function: p6df::modules::homebrew::casks::remove()
#
#>
######################################################################
p6df::core::homebrew::casks::remove() {

  local formuli=$(brew list --cask)

  local formula
  for formula in $(p6_echo "$formuli"); do
    NONINTERACTIVE=1 brew uninstall --cask "$formula"
  done
}

######################################################################
#<
#
# Function: p6df::modules::homebrew::brews::remove()
#
#>
######################################################################
p6df::core::homebrew::brews::remove() {

  local formuli=$(brew list --formula)

  local formula
  for formula in $(p6_echo "$formuli"); do
    NONINTERACTIVE=1 brew uninstall --ignore-dependencies --force "$formula"
  done
}

######################################################################
#<
#
# Function: p6df::modules::homebrew::nuke()
#
#>
######################################################################
p6df::core::homebrew::nuke() {

  p6_dir_rmrf "$HOMEBREW_PREFIX"
  p6_dir_mk "$HOMEBREW_PREFIX"
}

######################################################################
#<
#
# Function: p6df::modules::homebrew::install()
#
#  Environment:	 HEAD
#>
######################################################################
p6df::core::homebrew::install() {

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}
