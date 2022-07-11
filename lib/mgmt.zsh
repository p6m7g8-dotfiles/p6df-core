p6df::core::mgmt::modules::git::status() { p6df::core::mgmt::modules::foreach "p6_git_p6_status" }
p6df::core::mgmt::modules::git::diff()   { p6df::core::mgmt::modules::foreach "p6_git_p6_diff" }
p6df::core::mgmt::modules::git::pull()   { p6df::core::mgmt::modules::foreach "p6_git_p6_pull" }
p6df::core::mgmt::modules::git::push()   { p6df::core::mgmt::modules::foreach "echo p6_git_p6_push" }
p6df::core::mgmt::modules::git::sync()   { p6df::core::mgmt::git::pull; p6df::core::mgmt::git::push }

# ---------------------------------------------------------------------------

######################################################################
#<
#
# Function: p6df::core::mgmt::modules::foreach()
#
#  Environment:	 P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::core::mgmt::modules::foreach() {
    local callback="$1"

    (
        p6_dir_cd $P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
        local dir
        for dir in p6*; do
            p6df::core::mgmt::module::do "$dir" "$callback"
        done
    )
}

######################################################################
#<
#
# Function: p6df::core::mgmt::module::do(dir, callback)
#
#  Args:
#	dir -
#	callback -
#
#>
######################################################################
p6df::core::mgmt::module::do() {
    local dir="$1"
    local callback="$2"

    p6_h5 "$dir"
    (
        p6_dir_cd "$dir"
        p6_run_yield "$callback"
        p6_echo
    )

}
