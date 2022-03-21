######################################################################
#<
#
# Function: p6df::core::user::init()
#
#  Depends:	 p6_run
#  Environment:	 HOME
#>
######################################################################
p6df::core::user::init() {

  p6df::util::file::load "$HOME/.zsh-me"
}
