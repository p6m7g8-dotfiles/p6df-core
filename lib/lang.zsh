######################################################################
#<
#
# Function: p6df::core::lang::mgr::init(dir, name)
#
#  Args:
#	dir -
#	name -
#
#  Environment:	 ENV_ROOT P6_DFZ_LANGS_DISABLE XXX
#>
######################################################################
p6df::core::lang::mgr::init() {
    local dir="$1"
    local name="$2"

    local bin="$dir/bin/${name}env"
    if p6_string_blank "$P6_DFZ_LANGS_DISABLE" && p6_file_executable "$bin"; then
        local uc_name=$(p6_string_uc "$name")
        local root_name="${uc_name}ENV_ROOT"

        p6_env_export "$root_name" "$dir"
        p6_path_if "$dir/bin"
        eval "$(p6_run_code ${name}env init - zsh)" # XXX: use p6_run_*
    fi

    p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::lang::mgr::init2(cmd, name)
#
#  Args:
#	cmd -
#	name -
#
#  Environment:	 HOME
#>
######################################################################
p6df::core::lang::mgr::init2() {
    local cmd="$1"
    local name="$2"

    p6_path_if "$HOME/.local/bin"

    p6_return_void
}
