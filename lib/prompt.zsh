######################################################################
#<
#
# Function: p6df::core::prompt::init()
#
#  Environment:	 P6_DFZ_PROMPT_ENV_LINES P6_DFZ_PROMPT_LANG_LINES P6_DFZ_PROMPT_MOD_BOTTOM_LINES P6_DFZ_PROMPT_MOD_LINES PROMPT
#>
######################################################################
p6df::core::prompt::init() {

  p6_env_export P6_DFZ_PROMPT_LANG_LINES ""
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
#  Environment:	 EPOCHREALTIME _
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
     p6_echo "langs:\t\t  ${langs_line}"
  fi

  local -a _other_lines
  _other_lines=(
    ${=P6_DFZ_PROMPT_ENV_LINES}
    ${=P6_DFZ_PROMPT_MOD_LINES}
    ${=P6_DFZ_PROMPT_MOD_BOTTOM_LINES}
  )

  for lf in $_other_lines; do
    p6df::core::prompt::runtime::line "$lf"
  done

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
    local cnt=$(p6_run_yield "$func")
    p6_time "$t3" "p6df::core::prompt::runtime: $func"
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
  local prompt_lang_func=$repo[prompt_lang]
  local prompt_env_func=$repo[prompt_env]
  local prompt_mod_func=$repo[prompt_mod]
  local prompt_mod_bottom_func=$repo[prompt_mod_bottom]
  unset repo

  if type -f "$prompt_lang_func" >/dev/null 2>&1; then
    p6df::core::prompt::line::add::lang "$prompt_lang_func"
  fi
  if type -f "$prompt_env_func" >/dev/null 2>&1; then
    p6df::core::prompt::line::add::env "$prompt_env_func"
  fi
  if type -f "$prompt_mod_func" >/dev/null 2>&1; then
    p6df::core::prompt::line::add::mod "$prompt_mod_func"
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
