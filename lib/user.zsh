######################################################################
#<
#
# Function: p6df::core::user::init()
#
#  Environment:	 HOME
#>
######################################################################
p6df::core::user::init() {

  p6df::core::util::file::load "$HOME/.zsh-me"
}
