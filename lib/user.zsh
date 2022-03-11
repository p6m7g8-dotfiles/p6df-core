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

######################################################################
#<
#
# Function: p6df::core::user::apps()
#
#  Depends:	 p6_run
#>
######################################################################
p6df::core::user::apps() {

  p6_run_parallel "0" "8" "$Apps" "p6_github_util_repo_clone_or_pull_no_ou" "/Users/pgollucci/src/github.com/apps"
}
