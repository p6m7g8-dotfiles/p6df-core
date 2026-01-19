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
        p6df::core::internal::pull "$dir" "$module"
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

    p6_run_dir "$dir" "p6_git_cli_status_s"

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

    p6_run_dir "$dir" "p6_git_cli_branch_verbose_verbose"

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

    p6_run_dir "$dir" "p6_git_cli_diff"

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

    p6_run_dir "$dir" "p6_git_cli_pull_rebase_autostash_ff_only"

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

    p6_run_dir "$dir" "p6_git_cli_push_u"

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

    p6_run_if "p6df::core::modules::langs"

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
# Function: p6df::core::internal::recurse::shortcircuit(module, dir, callback)
#
#  Args:
#	module -
#	dir -
#	callback -
#
#>
######################################################################
p6df::core::internal::recurse::shortcircuit() {
    local module="$1"
    local dir="$2"
    local callback="$3"

    # short circuit
    local breaker_var=$(p6df::core::module::env::name "P6_DFZ_env_${module}" "$dir" "${callback}")
    local breaker_val
    p6_run_code "breaker_val=\$${breaker_var}"

    if p6_string_eq "$breaker_val" "1"; then
        p6df::core::internal::debug "short circuit: <- $module, $dir, $callback"
        return 0
    else
        p6df::core::internal::debug "continue -> $module, $dir, $callback"
    fi

    p6_run_code "${breaker_var}=1"

    return 1
}

######################################################################
#<
#
# Function: p6df::core::internal::recurse::deps::run(module, func_deps, callback)
#
#  Args:
#	module -
#	func_deps -
#	callback -
#
#>
######################################################################
p6df::core::internal::recurse::deps::run() {
    local module="$1"
    local func_deps="$2"
    local callback="$3"

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
            return 1
            ;;
        esac
        ;;
    esac

    return 0
}

######################################################################
#<
#
# Function: str func_callback = p6df::core::internal::recurse::callback(callback, prefix)
#
#  Args:
#	callback -
#	prefix -
#
#  Returns:
#	str - func_callback
#
#>
######################################################################
p6df::core::internal::recurse::callback() {
    local callback="$1"
    local prefix="$2"

    case $callback in
    *p6df::core::internal* | *p6df::core::dev* | *p6_*) func_callback="$callback" ;;
    *) func_callback="$prefix::$callback" ;;
    esac

    p6df::core::internal::debug "CALLBACK: $func_callback"

    p6_return_str "$func_callback"
}

######################################################################
#<
#
# Function: p6df::core::internal::recurse::deps::each(dir, callback, ...)
#
#  Args:
#	dir -
#	callback -
#	... - 
#
#  Environment:	 M
#>
######################################################################
p6df::core::internal::recurse::deps::each() {
    local dir="$1"
    local callback="$2"
    shift 2

    local dep
    for dep in $ModuleDeps[@]; do
        p6df::core::internal::debug "DEP: p6df::core::internal::recurse[dep]($dep, $dir, $callback)"
        p6df::core::internal::recurse "$dep" "$dir" "$callback" "$@"
    done

    p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::internal::recurse(module, dir, [callback=], ...)
#
#  Args:
#	module -
#	dir -
#	OPTIONAL callback - []
#	... - 
#
#  Environment:	 EPOCHREALTIME M P6_DFZ_SRC_DIR
#>
######################################################################
p6df::core::internal::recurse() {
    local module="$1"
    local dir="$2"
    local callback="${3:-}"
    shift 3

    local t4=$EPOCHREALTIME
    p6df::core::internal::debug "=> p6df::core::internal::recurse($module, $dir, $callback)"

    if p6df::core::internal::recurse::shortcircuit "$module" "$dir" "$callback"; then
        return
    fi

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
    local func_deps="$main_prefix::deps"

    # skip when not appropriate
    # XXX: probably should be elsewhere
    # @ModuleDeps
    unset ModuleDeps
    if ! p6df::core::internal::recurse::deps::run "$module" "$func_deps" "$callback"; then
        return
    fi
    p6df::core::internal::recurse::deps::each "$dir" "$callback" "$@"

    # relative to module or fully qualified callback
    local func_callback=$(p6df::core::internal::recurse::callback "$callback" "$main_prefix")

    # tail recursive, do it at last
    p6df::core::internal::debug "run_if fc=[$func_callback] m=[$main_org/$main_repo] dir=[$P6_DFZ_SRC_DIR/$main_org/$main_repo] c=[$callback]"
    p6_run_if "$func_callback" "$main_org/$main_repo" "$P6_DFZ_SRC_DIR/$main_org/$main_repo" "$callback"

    p6_time "$t4" "p6df::core::internal::recurse($module, $dir, $callback)"

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

    p6_debug "p6df::core: $msg"
}
