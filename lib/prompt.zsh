######################################################################
#<
#
# Function: p6df::core::prompt::init()
#
#  Environment:	 PROMPT
#>
######################################################################
p6df::core::prompt::init() {

  p6_run_yield "p6df::user::prompt"

  p6df::core::prompt::line::add "p6df::core::lang::prompt::line"
#  p6df::core::prompt::line::add "p6df::core::lang::prompt::env::line"

  setopt prompt_subst
  PROMPT="\$(p6df::core::prompt::runtime)"
  PROMPT="
$PROMPT
"
}

######################################################################
#<
#
# Function: p6df::core::prompt::runtime()
#
#  Environment:	 EPOCHREALTIME P6_DFZ_PROMPT_LINES TOTAL
#>
######################################################################
p6df::core::prompt::runtime() {

  P6_DFZ_REAL_CMD=$(fc -ln -1)
  p6_log_disable

  local lf
  local t1=$EPOCHREALTIME
  for lf in $(p6_echo "$P6_DFZ_PROMPT_LINES"); do
    local t3=$EPOCHREALTIME
    local func="$lf"
    local cnt=$(p6_run_yield "$func")
    if ! p6_string_blank "$cnt"; then
      p6_echo "$cnt"
    fi
    p6_time "$t3" "p6df::core::prompt::runtime: $func"
  done
  p6_time "$t1" "TOTAL: p6df::core::prompt::runtime"

  p6_log_enable
}

######################################################################
#<
#
# Function: p6df::core::prompt::line::add(thing)
#
#  Args:
#	thing -
#
#  Environment:	 P6_DFZ_PROMPT_LINES
#>
######################################################################
p6df::core::prompt::line::add() {
  local thing="$1"

  local things="$P6_DFZ_PROMPT_LINES $thing"
  things=$(p6_word_unique "$things" | xargs)

  p6_env_export P6_DFZ_PROMPT_LINES "$things"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::prompt::line::remove(thing)
#
#  Args:
#	thing -
#
#  Environment:	 P6_DFZ_PROMPT_LINES
#>
######################################################################
p6df::core::prompt::line::remove() {
  local thing="$1"

  local removed=$(p6_word_not "$$P6_DFZ_PROMPT_LINES" "$thing" | xargs)
  p6_env_export P6_DFZ_PROMPT_LINES "$things"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::prompt::lang::line::add(thing)
#
#  Args:
#	thing -
#
#  Environment:	 P6_DFZ_PROMPT_LANG_LINES
#>
######################################################################
p6df::core::prompt::lang::line::add() {
  local thing="$1"

  local things="$P6_DFZ_PROMPT_LANG_LINES $thing"
  things=$(p6_word_unique "$things" | xargs)

  p6_env_export P6_DFZ_PROMPT_LANG_LINES "$things"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::prompt::lang::line::remove(thing)
#
#  Args:
#	thing -
#
#  Environment:	 P6_DFZ_PROMPT_LANG_LINES
#>
######################################################################
p6df::core::prompt::lang::line::remove() {
  local thing="$1"

  local removed=$(p6_word_not "$P6_DFZ_PROMPT_LANG_LINES" "$thing" | xargs)
  p6_env_export P6_DFZ_PROMPT_LANG_LINES "$removed"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::prompt::lang::env::off(lang)
#
#  Args:
#	lang -
#
#  Environment:	 P6_DFZ_PROMPT_LANG_LINES_OFF
#>
######################################################################
p6df::core::prompt::lang::env::off() {
  local lang="$1"

  local offss=$(p6_word_unique "$P6_DFZ_PROMPT_LANG_LINES_OFF $lang" | xargs)
  p6_env_export P6_DFZ_PROMPT_LANG_LINES_OFF "$offs"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::prompt::module::init(module)
#
#  Args:
#	module -
#
#  Environment:	 _2_
#>
######################################################################
p6df::core::prompt::module::init() {
  local module="$1"

  # %repo
  p6df::core::module::parse "$module"
  local prompt_func=$repo[prompt]
  unset repo

  local lang_name=$(p6_echo "$module" | sed -e 's,.*p6df-,,')
  local cmd=$(p6_lang_cmd_2_env "$lang_name")

  case $cmd in
  rb | go | j | node | js | jl | lua | pl | py | rust | scala | R)
    p6df::core::prompt::lang::line::add "$cmd"
    ;;
  *)
    if type -f "$prompt_func" >/dev/null 2>&1; then
      p6df::core::prompt::line::add "$prompt_func"
    fi
    ;;
  esac

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::core::lang::prompt::line()
#
#  Returns:
#	str - str
#
#  Environment:	 EPOCHREALTIME P6_DFZ_PROMPT_LANG_LINES
#>
######################################################################
p6df::core::lang::prompt::line() {
  local lang
  local str=""
  local f=0

  case "$P6_DFZ_REAL_CMD" in
  *env* | *cd*)
    cat /dev/null >"$P6_DFZ_PROMPT_CACHE"
    ;;
  esac

  for lang in $(p6_echo "$P6_DFZ_PROMPT_LANG_LINES"); do
    local t20=$EPOCHREALTIME

    local cnt=$(grep -E "^$lang=" "$P6_DFZ_PROMPT_CACHE" | tail -1 | cut -d '=' -f 2)

    if p6_string_blank "$cnt"; then
      local cnt=$(p6_lang_version "$lang")
      echo "$lang=$cnt" >>"$P6_DFZ_PROMPT_CACHE"
    fi
    p6_time "$t20" "p6_lang_version($lang)"

    if ! p6_string_blank "$cnt"; then
      if p6_string_eq "$f" "0"; then
        str="langs:\t\t  $lang:$cnt"
        f=1
      else
        str=$(p6_string_append "$str" "$lang:$cnt")
      fi
    fi
  done

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: str str = p6df::core::lang::prompt::env::line()
#
#  Returns:
#	str - str
#
#  Environment:	 P6_DFZ_PROMPT_LANG_LINES P6_DFZ_PROMPT_LANG_LINES_OFF P6_NL
#>
######################################################################
p6df::core::lang::prompt::env::line() {

  local lang
  local str
  local f=0
  for lang in $(p6_echo "$P6_DFZ_PROMPT_LANG_LINES"); do
    if ! p6_word_in "$lang" "$P6_DFZ_PROMPT_LANG_LINES_OFF"; then
      local func="p6df::modules::${lang}::env::prompt::info"
      local cnt=$(p6_run_yield "$func")
      if ! p6_string_blank "$cnt"; then
        if p6_string_eq "$f" "0"; then
          str="$cnt"
          f=1
        else
          str=$(p6_string_append "$str" "$P6_NL$cnt")
        fi
      fi
    fi
  done

  p6_return_str "$str"
}
