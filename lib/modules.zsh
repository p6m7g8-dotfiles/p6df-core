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
# Function: p6df::core::modules::mcp()
#
#>
######################################################################
p6df::core::modules::mcp() {

	p6df::core::modules::foreach "p6df::core::module::mcp"
}

######################################################################
#<
#
# Function: p6df::core::modules::profile::on(profile)
#
#  Args:
#	profile -
#
#  Environment:	 P6_DFZ_MODULES
#>
######################################################################
p6df::core::modules::profile::on() {
	local profile="$1"

	local module
	for module in $(p6_vertical "$P6_DFZ_MODULES"); do
		case "$module" in
		*1password*) continue ;;
		esac
		if command -v op >/dev/null 2>&1 && p6_string_blank_NOT "$OP_VAULT_NAME"; then
			p6df::core::profile::module::active "$module" "$profile"
		else
			p6df::core::profile::module::on "$module" "$profile" ""
		fi
	done
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

	p6df::core::homebrew::init

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
#  Environment:	 P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::core::modules::bootstrap::p6common() {
	local dir="${1:-$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6common}"

	p6df::core::file::load "$dir/init.zsh"
	p6df::modules::p6common::init "p6m7g8-dotfiles/p6common" "$dir"

	local breaker_var=$(p6df::core::module::env::name "P6_DFZ_env_p6m7g8-dotfiles/p6common" "$dir" "init")
	p6_env_export "$breaker_var" "1"
}
