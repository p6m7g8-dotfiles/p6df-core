# shellcheck shell=bash

######################################################################
#<
#
# Function: p6df::core::module::_fetch()
#
#>
######################################################################
p6df::core::module::_fetch() {
    local dir="$1"
    local module="$2"

    if ! p6_dir_exists "$dir"; then
        p6_msg "gh repo clone $module $dir"
        p6_log "gh repo clone $module $dir"

        gh repo clone $module $dir
    fi
}

######################################################################
#<
#
# Function: p6df::core::module::_update(dir, module)
#
#  Args:
#	dir -
#	module -
#
#>
######################################################################
p6df::core::module::_update() {
    local dir="$1"
    local module="$2"

    if ! p6_dir_exists "$dir"; then
        p6df::core::module::_fetch "$dir" "$module"
    else
        p6_msg_no_nl "$dir: "
        p6_run_dir "$dir" "p6_git_p6_pull"
    fi
}

######################################################################
#<
#
# Function: p6df::core::module::_recurse(module, callback, ...)
#
#  Args:
#	module -
#	callback -
#	... - 
#
#  Environment:	 P6_DFZ_ P6_DFZ_SRC_DIR
#>
######################################################################
p6df::core::module::_recurse() {
    local module="$1"
    local callback="$2"
    shift 2

    p6_log "=> p6df::core::module::_recurse($module, $callback)"

    # short circuit
    local breaker_var=$(p6df::core::module::env::name "P6_DFZ_env_${module}-${callback}")
    local breaker_val
    p6_run_code "breaker_val=\$${breaker_var}"

    if p6_string_eq "$breaker_val" "1"; then
        p6_log "short circuit"
        return
    else
        p6_log "continue"
    fi
    p6_run_code "${breaker_var}=1"

    # load
    # %repo
    p6df::core::module::parse "$module"
    p6df::core::module::source "$repo[load_path]" "$repo[extra_load_path]"
    local main_repo=$repo[repo]
    local main_org=$repo[org]
    local main_module="$main_org/$main_repo"
    local main_prefix=$repo[prefix]
    unset repo

    # deps
    # @ModuleDeps
    unset ModuleDeps
    local func_deps="$main_prefix::deps"
    p6_run_if "$func_deps"

    local dep
    for dep in $ModuleDeps[@]; do
        p6_log "p6df::core::module::_recurse[dep]($dep, $callback)"
        p6df::core::module::_recurse "$dep" "$callback" "$@"
    done

    # relative to module or fully qualified callback
    local func_callback
    case $callback in
    *p6df::core::*) func_callback="$callback" ;;
    *) func_callback="$main_prefix::$callback" ;;
    esac

    # tail recursive, do it at last
    p6_run_if "$func_callback" "$P6_DFZ_SRC_DIR/$main_org/$main_repo" "$main_org/$main_repo"

    p6_return_void
}
