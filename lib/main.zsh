######################################################################
#<
#
# Function: p6df::core::main::init()
#
#>
######################################################################
p6df::core::main::init() {

  p6df::core::util::timing::init

  p6df::core::user::init

  p6df::core::path::init
  p6df::core::path::cd::init
  p6df::core::aliases::init

  p6df::core::modules::init
  p6df::core::theme::init
  p6df::core::prompt::init
}
