# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::core::modules::load()
#
#>
######################################################################
p6df::core::modules::load() {

	p6df::core::modules::foreach "p6df::core::module::init"
}

######################################################################
#<
#
# Function: p6df::core::modules::brews()
#
#>
######################################################################
p6df::core::modules::brews() {

	p6df::core::modules::foreach "p6df::core::module::brews"
}

######################################################################
#<
#
# Function: p6df::core::modules::langs()
#
#>
######################################################################
p6df::core::modules::langs() {

	p6df::core::modules::foreach "p6df::core::module::langs"
}

######################################################################
#<
#
# Function: p6df::core::modules::vscodes()
#
#>
######################################################################
p6df::core::modules::vscodes() {

	p6df::core::modules::foreach "p6df::core::module::vscodes"
}

######################################################################
#<
#
# Function: p6df::core::modules::symlinks()
#
#>
######################################################################
p6df::core::modules::symlinks() {

	p6df::core::modules::foreach "p6df::core::module::symlinks"
}

######################################################################
#<
#
# Function: p6df::core::modules::init()
#
#  Environment:	 HOMEBREW_PREFIX
#>
######################################################################
p6df::core::modules::init() {

	p6df::user::modules
	p6df::user::modules::init::pre

	p6df::core::homebrew::init # HOMEBREW_PREFIX, m1 et al

	p6df::core::modules::load

	p6df::user::modules::init::post
}

######################################################################
#<
#
# Function: p6df::core::modules::foreach(callback)
#
#  Args:
#	callback -
#
#  Environment:	 P6_DFZ_MODULES P6_DFZ_SRC_DIR
#>
######################################################################
p6df::core::modules::foreach() {
	local callback="$1"

	local module
	for module in $(p6_vertical "$P6_DFZ_MODULES"); do
		p6_run_yield "$callback $module $P6_DFZ_SRC_DIR/$module"
	done
}

######################################################################
#<
#
# Function: p6df::core::modules::bootstrap::p6common([dir=$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6common])
#
#  Args:
#	OPTIONAL dir - [$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6common]
#
#  Environment:	 P6_DFZ_ P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::core::modules::bootstrap::p6common() {
	local dir="${1:-$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6common}"

	p6df::core::file::load "$dir/init.zsh"
	p6df::modules::p6common::init "p6m7g8-dotfiles/p6common" "$dir"

	local breaker_var=$(p6df::core::module::env::name "P6_DFZ_env_p6m7g8-dotfiles/p6common" "$dir" "init")
	p6_env_export "$breaker_var" "1"
}
