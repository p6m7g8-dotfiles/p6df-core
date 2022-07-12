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
# Function: p6df::core::modules::load()
#
#>
######################################################################
p6df::core::modules::load() {

	p6df::core::modules::foreach "p6df::core::module::load"
}

p6df::core::modules::brews()    { p6df::core::modules::foreach "p6df::core::module::brews" }
p6df::core::modules::langs()    { p6df::core::modules::foreach "p6df::core::module::langs" }
p6df::core::modules::vscodes()  { p6df::core::modules::foreach "p6df::core::module::vscodes" }
p6df::core::modules::symlinks() { p6df::core::modules::foreach "p6df::core::module::symlinks" }

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
# Function: p6df::core::modules::bootstrap::p6common()
#
#  Environment:	 P6_ P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::core::modules::bootstrap::p6common() {

	local dir="$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6common"
	p6df::core::file::load "$dir/lib/_bootstrap.sh"

	p6_bootstrap

	p6_env_export "PL_env_p6m7g8_dotfiles_p6common_init" "1"
}
