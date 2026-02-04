######################################################################
#<
#
# Function: p6df::core::main::init()
#
#  Environment:	 EPOCHREALTIME P6_DFZ_SRC_P6M7G8_DOTFILES_DIR P6_NL
#>
######################################################################
p6df::core::main::init() {

	p6df::core::timing::init

	local t0=$EPOCHREALTIME
	p6df::core::main::self::init

	p6_time "$t0" "p6df::core::main::self::init()"

	p6df::core::user::init

	p6df::core::path::init "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-core"
	p6df::core::path::cd::init
	p6df::core::aliases::init

	local t1=$EPOCHREALTIME
	p6df::core::prompt::init
	p6df::core::modules::init
	p6_time "$t1" "p6df::core::modules::init()"

	p6df::core::theme::init

	p6_time "$t0" "STARTED: p6df::core::main::init()$P6_NL"
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

	if ! test -d /tmp/p6; then
	    mkdir -p /tmp/p6
	fi

	local file
	for file in $P6_DFZ_LIB_DIR/*.zsh; do
		p6df::core::file::load "$file"
	done

	p6df::core::modules::bootstrap::p6common
}

######################################################################
#<
#
# Function: p6df::core::timing::init()
#
#>
######################################################################
p6df::core::timing::init() {

	zmodload zsh/datetime

	return
}
