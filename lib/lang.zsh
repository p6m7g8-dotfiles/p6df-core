######################################################################
#<
#
# Function: p6df::core::lang::mgr::init(dir, name)
#
#  Args:
#	dir -
#	name -
#
#  Environment:	 P6_DFZ_LANGS_DISABLE
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
# Function: str label:$ver = p6df::core::lang::prompt::lang(label, mgr_cmd, sys_cmd)
#
#  Args:
#	label -
#	mgr_cmd -
#	sys_cmd -
#
#  Returns:
#	str - label:$ver
#
#>
######################################################################
p6df::core::lang::prompt::lang() {
    local label="$1"
    local mgr_cmd="$2"
    local sys_cmd="$3"

    local ver_mgr
    ver_mgr=$(eval "$mgr_cmd" 2>/dev/null)
    if p6_string_blank "$ver_mgr"; then
        ver_mgr="system"
    fi

    local ver
    if p6_string_eq "$ver_mgr" "system"; then
        local v
        v=$(eval "$sys_cmd" 2>/dev/null)
        if p6_string_blank "$v"; then
            ver="sys:no"
        else
            ver="sys@$v"
        fi
    else
        ver="$ver_mgr"
    fi

    p6_return_str "$label:$ver"
}
