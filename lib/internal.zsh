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
        p6_run_write_cmd "gh repo clone $module $dir"
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
# Function: p6df::core::internal::branch(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#>
######################################################################
p6df::core::internal::branch() {
    local _module="$1"
    local dir="$2"

    p6_run_dir "$dir" "p6_git_p6_branch"

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
# Function: p6df::core::internal::diag(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::internal::diag() {
    local module="$1"
    local dir="$2"

    p6_h5 "m=[$module], d=[$dir]"

    p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::internal::langs(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::internal::langs() {
    local module="$1"
    local dir="$2"

    local function="${__p6_prefix}::langs"
    p6_run_if "$function"
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
#  Environment:	 EPOCHREALTIME P6_DFZ_ P6_DFZ_SRC_DIR
#>
######################################################################
p6df::core::internal::recurse() {
    local module="$1"
    local dir="$2"
    local callback="$3"
    shift 3

    local t4=$EPOCHREALTIME
    p6df::core::internal::debug "=> p6df::core::internal::recurse($module, $dir, $callback)"

    # short circuit
    local breaker_var=$(p6df::core::module::env::name "P6_DFZ_env_${module}" "$dir" "${callback}")
    local breaker_val
    p6_run_code "breaker_val=\$${breaker_var}"

    if p6_string_eq "$breaker_val" "1"; then
        p6df::core::internal::debug "short circuit: <- $module, $dir, $callback"
        return
    else
        p6df::core::internal::debug "continue -> $module, $dir, $callback"
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

    case $module in
    *p6*)
        p6_run_if "$func_deps"
        ;;
    *)
        case $callback in
        *fetch* | *update*)
            p6_run_if "$func_deps"
            ;;
        *)
            p6df::core::internal::debug "Not processing m=[$module]"
            return
            ;;
        esac
        ;;
    esac

    local dep
    for dep in $ModuleDeps[@]; do
        p6df::core::internal::debug "p6df::core::internal::recurse[dep]($dep, $dir, $callback)"
        p6df::core::internal::recurse "$dep" "$dir" "$callback" "$@"
    done

    # relative to module or fully qualified callback
    local func_callback
    case $callback in
    *p6df::core::internal* | *p6_*) func_callback="$callback" ;;
    *) func_callback="$main_prefix::$callback" ;;
    esac

    # tail recursive, do it at last
    p6df::core::internal::debug "run_if fc=[$func_callback] m=[$main_org/$main_repo] dir=[$P6_DFZ_SRC_DIR/$main_org/$main_repo] c=[$callback]"
    p6_run_if "$func_callback" "$main_org/$main_repo" "$P6_DFZ_SRC_DIR/$main_org/$main_repo" "$callback"

    local t5=$EPOCHREALTIME
    p6_time "$t4" "$t5" "p6df::core::internal::recurse($module, $dir, $callback)"

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

######################################################################
#<
#
# Function: p6df::core::internal::debug(msg)
#
#  Args:
#	msg -
#
#>
######################################################################
p6df::core::internal::debug() {
    local msg="$1"

    p6_debug "p6df::core:: $msg"
}
