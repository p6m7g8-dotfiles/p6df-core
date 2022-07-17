# shellcheck shell=bash

######################################################################
#<
#
# Function: p6df::core::internal::fetch()
#
#>
######################################################################
p6df::core::internal::fetch() {
    local module="$1"
    local dir="$2"

    if ! p6_dir_exists "$dir"; then
        p6_msg "gh repo clone $module $dir"
        p6_log "gh repo clone $module $dir"

        gh repo clone $module $dir
    fi
}

######################################################################
#<
#
# Function: p6df::core::internal::update(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::internal::update() {
    local module="$1"
    local dir="$2"

    if ! p6_dir_exists "$dir"; then
        p6df::core::internal::fetch "$dir" "$module"
    else
        p6_msg_no_nl "$dir: "
        p6_run_dir "$dir" "p6_git_p6_pull"
    fi
}

######################################################################
#<
#
# Function: p6df::core::internal::status(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#>
######################################################################
p6df::core::internal::status() {
    local _module="$1"
    local dir="$2"

    p6_run_dir "$dir" "p6_git_p6_status"

    p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::internal::diff(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#>
######################################################################
p6df::core::internal::diff() {
    local _module="$1"
    local dir="$2"

    p6_run_dir "$dir" "p6_git_p6_diff"

    p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::internal::pull(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#>
######################################################################
p6df::core::internal::pull() {
    local _module="$1"
    local dir="$2"

    p6_run_dir "$dir" "p6_git_p6_pull"

    p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::internal::push(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#>
######################################################################
p6df::core::internal::push() {
    local _module="$1"
    local dir="$2"

    p6_run_dir "$dir" "p6_git_p6_push"

    p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::internal::doc(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#>
######################################################################
p6df::core::internal::doc() {
    local _module="$1"
    local dir="$2"

    p6_run_dir "$dir" "p6_cicd_doc_gen"

    p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::internal::recurse(module, dir, callback, ...)
#
#  Args:
#	module -
#	dir -
#	callback -
#	... - 
#
#  Environment:	 P6_DFZ_ P6_DFZ_SRC_DIR
#>
######################################################################
p6df::core::internal::recurse() {
    local module="$1"
    local dir="$2"
    local callback="$3"
    shift 3

    p6_log "=> p6df::core::internal::recurse($module, $dir, $callback)"

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
    p6df::core::module::parse "$module" "$dir"
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
        p6_log "p6df::core::internal::recurse[dep]($dep, $dir, $callback)"
        p6df::core::internal::recurse "$dep" "$dir" "$callback" "$@"
    done

    # relative to module or fully qualified callback
    local func_callback
    case $callback in
    *p6df::core::* | *p6_*) func_callback="$callback" ;;
    *) func_callback="$main_prefix::$callback" ;;
    esac

    # tail recursive, do it at last
    p6_run_if "$func_callback" "$main_org/$main_repo" "$P6_DFZ_SRC_DIR/$main_org/$main_repo" "$callbaack"

    p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::source(relpath, relaux)
#
#  Args:
#	relpath -
#	relaux -
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::core::module::source() {
    local relpath="$1"
    local relaux="$2"

    [[ -n "$relaux" ]] && p6df::core::file::load "$P6_DFZ_SRC_DIR/$relaux"
    p6df::core::file::load "$P6_DFZ_SRC_DIR/$relpath"
}
