# shellcheck shell=bash

######################################################################
#<
#
# Function: p6df::core::homebrew::init()
#
#  Environment:	 HOMEBREW_CELLAR HOMEBREW_EDITOR HOMEBREW_NO_ANALYTICS HOMEBREW_PREFIX HOMEBREW_REPOSITORY INFOPATH
#>
#/ Synopsis
#/   Warning: Using vim because no editor was set in the environment.
#/   This may change in the future, so we recommend setting EDITOR,
#/   or HOMEBREW_EDITOR to your preferred text editor.
######################################################################
p6df::core::homebrew::init() {

  local homebrew_prefix=$(brew --config | awk -F: '/PREFIX/ { print $2 }' | sed -e 's, ,,g')

  p6_env_export "HOMEBREW_NO_ANALYTICS" "1"
  p6_env_export "HOMEBREW_EDITOR" "vim"
  p6_env_export "HOMEBREW_CELLAR" "$homebrew_prefix/Cellar"
  p6_env_export "HOMEBREW_REPOSITORY" "$homebrew_prefix"
  p6_env_export "HOMEBREW_PREFIX" "$homebrew_prefix"
  p6_env_export "INFOPATH" "$homebrew_prefix/share/info:${INFOPATH:-}"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::aliases::init()
#
#>
######################################################################
p6df::core::homebrew::aliases::init() {

  p6_alias "p6_hbr" "p6df::core::homebrew::remove"
  p6_alias "p6_hbcr" "p6df::core::homebrew::casks::remove"
  p6_alias "p6_hbbr" "p6df::core::homebrew::brews::remove"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::cmd::brew(...)
#
#  Args:
#	... -
#
#>
#/ Synopsis
#/   Wrapper function to execute brew commands
######################################################################
p6df::core::homebrew::cmd::brew() {
  shift 0

  brew "$@"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::cli::brew::install(...)
#
#  Args:
#	... -
#
#>
######################################################################
p6df::core::homebrew::cli::brew::install() {
  shift 0

  p6df::core::homebrew::cmd::brew install "$@"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::cli::brew::services::start(...)
#
#  Args:
#	... -
#
#>
######################################################################
p6df::core::homebrew::cli::brew::services::start() {
  shift 0

  p6df::core::homebrew::cmd::brew services start "$@"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::cli::brew::services::stop(...)
#
#  Args:
#	... -
#
#>
######################################################################
p6df::core::homebrew::cli::brew::services::stop() {
  shift 0

  p6df::core::homebrew::cmd::brew services stop "$@"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::remove()
#
#>
#/ Synopsis
#/   Removes all casks and brews
######################################################################
p6df::core::homebrew::remove() {

  p6df::core::homebrew::casks::remove
  p6df::core::homebrew::brews::remove

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::casks::remove()
#
#>
######################################################################
p6df::core::homebrew::casks::remove() {

  local formuli=$(brew list --cask)

  local formula
  for formula in $(p6_echo "$formuli"); do
    NONINTERACTIVE=1 brew uninstall --cask "$formula"
  done

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::brews::remove()
#
#>
######################################################################
p6df::core::homebrew::brews::remove() {

  local formuli=$(brew list --formula)

  local formula
  for formula in $(p6_echo "$formuli"); do
    NONINTERACTIVE=1 brew uninstall --ignore-dependencies --force "$formula"
  done

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::nuke()
#
#  Environment:	 HOMEBREW_PREFIX
#>
#/ Synopsis
#/   Removes and recreates the HOMEBREW_PREFIX directory
######################################################################
p6df::core::homebrew::nuke() {

  p6_dir_rmrf "$HOMEBREW_PREFIX"
  p6_dir_mk "$HOMEBREW_PREFIX"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::install()
#
#>
#/ Synopsis
#/   Installs Homebrew from the official GitHub repository
######################################################################
p6df::core::homebrew::install() {

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  p6_return_void
}
