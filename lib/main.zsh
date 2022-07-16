######################################################################
#<
#
# Function: p6df::core::main::init()
#
#  Environment:	 EPOCHREALTIME P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::core::main::init() {

	p6df::core::main::self::init
	local t99=$EPOCHREALTIME

	p6df::core::user::init

	p6df::core::path::init "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-core"
	p6df::core::path::cd::init
	p6df::core::aliases::init

	p6df::core::modules::init

	p6df::core::theme::init
	p6df::core::prompt::init

	local t100=$EPOCHREALTIME
	p6_time "$t99" "$t100" "p6df::core::main::init()"
	p6_time "0" "0" "-----------------------------------"
}

######################################################################
#<
#
# Function: p6df::core::main::self::init()
#
#  Environment:	 P6_DFZ_LIB_DIR
#>
######################################################################
p6df::core::main::self::init() {

	# boostrap
	. $P6_DFZ_LIB_DIR/file.zsh

	local file
	for file in $P6_DFZ_LIB_DIR/*.zsh; do
		p6df::core::file::load "$file"
	done

	p6df::core::timing::init

	p6df::core::modules::bootstrap::p6common
}
