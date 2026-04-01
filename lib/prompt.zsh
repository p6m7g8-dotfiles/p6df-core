######################################################################
#<
#
# Function: p6df::core::prompt::init()
#
#  Environment:	 P6_DFZ_PROMPT_CONTEXT_LINES P6_DFZ_PROMPT_ENV_LINES P6_DFZ_PROMPT_LANG_LINES P6_DFZ_PROMPT_MOD_BOTTOM_LINES P6_DFZ_PROMPT_MOD_LINES P6_DFZ_PROMPT_RUNTIME_LINES P6_DFZ_PROMPT_SYSTEM_LINES PROMPT
#>
######################################################################
p6df::core::prompt::init() {

  p6_env_export P6_DFZ_PROMPT_LANG_LINES ""
  p6_env_export P6_DFZ_PROMPT_RUNTIME_LINES ""
  p6_env_export P6_DFZ_PROMPT_CONTEXT_LINES ""
  p6_env_export P6_DFZ_PROMPT_SYSTEM_LINES ""
  p6_env_export P6_DFZ_PROMPT_ENV_LINES ""
  p6_env_export P6_DFZ_PROMPT_MOD_LINES ""
  p6_env_export P6_DFZ_PROMPT_MOD_BOTTOM_LINES ""

  p6_run_yield "p6df::user::prompt"

  setopt prompt_subst
 PROMPT="\$(p6df::core::prompt::runtime)"
 PROMPT="
$PROMPT
"

  p6_return_void
}

######################################################################
#<
#
# Function: stream  = p6df::core::prompt::runtime()
#
#  Returns:
#	stream -
#
#>
######################################################################
p6df::core::prompt::runtime() {

  P6_DFZ_REAL_CMD=$(fc -ln -1)
  p6_log_disable
  p6df::core::prompt::runtime::lines
  p6_log_enable

  p6_return_stream
}

######################################################################
#<
#
# Function: stream  = p6df::core::prompt::runtime::lines()
#
#  Returns:
#	stream -
#
#  Environment:	 EPOCHREALTIME P6_DFZ_PROMPT_IN_VSCODE _
#>
######################################################################
p6df::core::prompt::runtime::lines() {

  local t1=$EPOCHREALTIME

  local -a _lang_lines
  local langs_line=""
  local sep=""

  _lang_lines=(${=P6_DFZ_PROMPT_LANG_LINES})

  local lf
  for lf in $_lang_lines; do
    local cnt=$(p6df::core::prompt::runtime::line "$lf")
    langs_line+="${sep}${cnt}"
    sep=" "
  done

  if p6_string_blank_NOT "$langs_line"; then
     p6_echo "$(p6_string_space_pad "langs:" 16)${langs_line}"
  fi

  if p6_string_blank "$P6_DFZ_PROMPT_IN_VSCODE"; then

    if p6_string_blank "$P6_DFZ_RUNTIME_DISABLE"; then
      local -a _runtime_lines=( ${=P6_DFZ_PROMPT_RUNTIME_LINES} )
      for lf in $_runtime_lines; do p6df::core::prompt::runtime::line "$lf"; done
    fi

    if p6_string_blank "$P6_DFZ_CONTEXT_DISABLE"; then
      local -a _context_lines=( ${=P6_DFZ_PROMPT_CONTEXT_LINES} )
      for lf in $_context_lines; do p6df::core::prompt::runtime::line "$lf"; done
    fi

    if p6_string_blank "$P6_DFZ_SYSTEM_DISABLE"; then
      local -a _system_lines=( ${=P6_DFZ_PROMPT_SYSTEM_LINES} )
      for lf in $_system_lines; do p6df::core::prompt::runtime::line "$lf"; done
    fi

    if p6_string_blank "$P6_DFZ_ENV_DISABLE"; then
      local -a _env_lines=( ${=P6_DFZ_PROMPT_ENV_LINES} )
      for lf in $_env_lines; do p6df::core::prompt::runtime::line "$lf"; done
    fi

    if p6_string_blank "$P6_DFZ_MOD_DISABLE"; then
      local -a _mod_lines=( ${=P6_DFZ_PROMPT_MOD_LINES} )
      for lf in $_mod_lines; do p6df::core::prompt::runtime::line "$lf"; done
    fi

  fi

  if p6_string_blank "$P6_DFZ_BOTTOM_DISABLE"; then
    local -a _bottom_lines=( ${=P6_DFZ_PROMPT_MOD_BOTTOM_LINES} )
    for lf in $_bottom_lines; do p6df::core::prompt::runtime::line "$lf"; done
  fi

  p6_time "$t1" "TOTAL: p6df::core::prompt::runtime"

  p6_return_stream
}

######################################################################
#<
#
# Function: str cnt = p6df::core::prompt::runtime::line(func)
#
#  Args:
#	func -
#
#  Returns:
#	str - cnt
#
#  Environment:	 EPOCHREALTIME
#>
######################################################################
p6df::core::prompt::runtime::line() {
    local func="$1"

    local t3=$EPOCHREALTIME
    local raw=$(p6_run_yield "$func")
    p6_time "$t3" "p6df::core::prompt::runtime: $func"

    local cnt
    if p6_string_blank_NOT "$raw"; then
        local -a parts
        parts=("${(z)raw}")
        if [[ ${#parts} -ge 2 && "${parts[2]}" == \$* ]]; then
            cnt=$(p6df::core::profile::default::mod "${parts[1]}" "${(@)parts[2,-1]}")
        else
            cnt="$raw"
        fi
    fi

    if p6_string_blank_NOT "$cnt"; then
        p6_return_str "$cnt"
    else
        p6_return_void
    fi
}

######################################################################
#<
#
# Function: p6df::core::prompt::module::init(module)
#
#  Args:
#	module -
#
#>
######################################################################
p6df::core::prompt::module::init() {
  local module="$1"

  # %repo
  p6df::core::module::parse "$module"
  local prompt_init_func=$repo[prompt_init]
  local prompt_lang_func=$repo[prompt_lang]
  local prompt_runtime_func=$repo[prompt_runtime]
  local prompt_context_func=$repo[prompt_context]
  local prompt_system_func=$repo[prompt_system]
  local prompt_env_func=$repo[prompt_env]
  local profile_mod_func=$repo[profile_mod]
  local prompt_mod_bottom_func=$repo[prompt_mod_bottom]
  unset repo

  if type -f "$prompt_init_func" >/dev/null 2>&1; then
    p6_run_yield "$prompt_init_func"
  fi
  if type -f "$prompt_lang_func" >/dev/null 2>&1; then
    p6df::core::prompt::line::add::lang "$prompt_lang_func"
  fi
  if type -f "$prompt_runtime_func" >/dev/null 2>&1; then
    p6df::core::prompt::line::add::runtime "$prompt_runtime_func"
  fi
  if type -f "$prompt_context_func" >/dev/null 2>&1; then
    p6df::core::prompt::line::add::context "$prompt_context_func"
  fi
  if type -f "$prompt_system_func" >/dev/null 2>&1; then
    p6df::core::prompt::line::add::system "$prompt_system_func"
  fi
  if type -f "$prompt_env_func" >/dev/null 2>&1; then
    p6df::core::prompt::line::add::env "$prompt_env_func"
  fi
  if type -f "$profile_mod_func" >/dev/null 2>&1; then
    p6df::core::prompt::line::add::mod "$profile_mod_func"
  fi
  if type -f "$prompt_mod_bottom_func" >/dev/null 2>&1; then
    p6df::core::prompt::line::add::mod::bottom "$prompt_mod_bottom_func"
  fi

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::prompt::line::add::lang(func)
#
#  Args:
#	func -
#
#  Environment:	 P6_DFZ_PROMPT_LANG_LINES
#>
######################################################################
p6df::core::prompt::line::add::lang() {
  local func="$1"

  p6_env_export P6_DFZ_PROMPT_LANG_LINES "${P6_DFZ_PROMPT_LANG_LINES:+$P6_DFZ_PROMPT_LANG_LINES }$func"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::prompt::line::add::runtime(func)
#
#  Args:
#	func -
#
#  Environment:	 P6_DFZ_PROMPT_RUNTIME_LINES
#>
######################################################################
p6df::core::prompt::line::add::runtime() {
  local func="$1"

  p6_env_export P6_DFZ_PROMPT_RUNTIME_LINES "${P6_DFZ_PROMPT_RUNTIME_LINES:+$P6_DFZ_PROMPT_RUNTIME_LINES }$func"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::prompt::line::add::context(func)
#
#  Args:
#	func -
#
#  Environment:	 P6_DFZ_PROMPT_CONTEXT_LINES
#>
######################################################################
p6df::core::prompt::line::add::context() {
  local func="$1"

  p6_env_export P6_DFZ_PROMPT_CONTEXT_LINES "${P6_DFZ_PROMPT_CONTEXT_LINES:+$P6_DFZ_PROMPT_CONTEXT_LINES }$func"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::prompt::line::add::system(func)
#
#  Args:
#	func -
#
#  Environment:	 P6_DFZ_PROMPT_SYSTEM_LINES
#>
######################################################################
p6df::core::prompt::line::add::system() {
  local func="$1"

  p6_env_export P6_DFZ_PROMPT_SYSTEM_LINES "${P6_DFZ_PROMPT_SYSTEM_LINES:+$P6_DFZ_PROMPT_SYSTEM_LINES }$func"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::prompt::line::add::env(func)
#
#  Args:
#	func -
#
#  Environment:	 P6_DFZ_PROMPT_ENV_LINES
#>
######################################################################
p6df::core::prompt::line::add::env() {
  local func="$1"

  p6_env_export P6_DFZ_PROMPT_ENV_LINES "${P6_DFZ_PROMPT_ENV_LINES:+$P6_DFZ_PROMPT_ENV_LINES }$func"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::prompt::line::add::mod(func)
#
#  Args:
#	func -
#
#  Environment:	 P6_DFZ_PROMPT_MOD_LINES
#>
######################################################################
p6df::core::prompt::line::add::mod() {
  local func="$1"

  p6_env_export P6_DFZ_PROMPT_MOD_LINES "${P6_DFZ_PROMPT_MOD_LINES:+$P6_DFZ_PROMPT_MOD_LINES }$func"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::prompt::line::add::mod::bottom(func)
#
#  Args:
#	func -
#
#  Environment:	 P6_DFZ_PROMPT_MOD_BOTTOM_LINES
#>
######################################################################
p6df::core::prompt::line::add::mod::bottom() {
  local func="$1"

  p6_env_export P6_DFZ_PROMPT_MOD_BOTTOM_LINES "${P6_DFZ_PROMPT_MOD_BOTTOM_LINES:+$P6_DFZ_PROMPT_MOD_BOTTOM_LINES }$func"

  p6_return_void
}
