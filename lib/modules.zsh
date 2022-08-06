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
#>
######################################################################
p6df::core::modules::init() {

	p6df::user::modules
	p6df::user::modules::init::pre

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
#  Environment:	 P6_DFZ_MODULES
#>
######################################################################
p6df::core::modules::foreach() {
	local callback="$1"

	local module
	for module in $(p6_vertical "$P6_DFZ_MODULES"); do
		p6_run_yield "$callback $module"
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

	p6df::core::internal::debug "loading p6common"
	p6_env_export "P6_DFZ_env_p6m7g8_dotfiles_p6common_init" "1"
}
