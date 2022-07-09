######################################################################
#<
#
# Function: p6df::core::prompt::init()
#
#  Depends:	 p6_echo
#>
######################################################################
p6df::core::prompt::init() {
  p6df::core::util::run::if "p6df::user::prompt"

  p6df::core::prompt::process
}

######################################################################
#<
#
# Function: p6df::core::prompt::process()
#
#  Depends:	 p6_echo
#  Environment:	 PROMPT
#>
######################################################################
p6df::core::prompt::process() {

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
#  Depends:	 p6_echo p6_env p6_string p6_time
#  Environment:	 EPOCHREALTIME P6_DFZ_PROMPT_LINES PROMPT
#>
######################################################################
p6df::core::prompt::runtime() {

  local lf
  local t1=$EPOCHREALTIME
  for lf in $(echo "$P6_DFZ_PROMPT_LINES"); do
    local t3=$EPOCHREALTIME
    local func="$lf"
    local cnt=$(p6df::core::util::run::if "$func")
    if ! p6_string_blank "$cnt"; then
      p6_echo "$cnt"
    fi
    local t4=$EPOCHREALTIME
    p6_time "$t3" "$t4" "PROMPT CALLBACK: $func"
  done
  local t2=$EPOCHREALTIME
  p6_time "$t1" "$t2" "PROMPT CALLBACK TOTAL"
}

######################################################################
#<
#
# Function: p6df::core::prompt::line::add(thing)
#
#  Args:
#	thing -
#
#  Depends:	 p6_env
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
#  Depends:	 p6_echo p6_env
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
#  Depends:	 p6_env
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
#  Depends:	 p6_echo p6_env
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
#  Depends:	 p6_echo p6_env p6_lang
#  Environment:	 P6_DFZ_PROMPT_LANG_LINES_OFF
#>
######################################################################
p6df::core::prompt::lang::env::off() {
  local lang="$1"

  local offs="$P6_DFZ_PROMPT_LANG_LINES_OFF $lang"
  offss=$(p6_word_unique "$offs" | xargs)

  p6_env_export P6_DFZ_PROMPT_LANG_LINES_OFF "$offs"

  p6_return_void
}

######################################################################
#<
#
# Function: p6_lang_prompt_info()
#
#  Depends:	 p6_echo p6_lang p6_string
#  Environment:	 P6_DFZ_PROMPT_LANG_LINES
#>
######################################################################
p6_lang_prompt_info() {

  local lang
  local str
  local f=0
  for lang in $(p6_echo "$P6_DFZ_PROMPT_LANG_LINES"); do
    local cnt=$(p6_lang_version "$lang")
    if ! p6_string_blank "$cnt"; then
      if p6_string_eq "$f" "0"; then
        str="langs:\t  $lang:$cnt"
        f=1
      else
        str=$(p6_string_append "$str" " $lang:$cnt")
      fi
    fi
  done

  p6_echo "$str"
}

######################################################################
#<
#
# Function: p6_lang_envs_prompt_info()
#
#  Depends:	 p6_echo p6_string p6_word
#  Environment:	 P6_DFZ_PROMPT_LANG_LINES P6_DFZ_PROMPT_LANG_LINES_OFF P6_NL
#>
######################################################################
p6_lang_envs_prompt_info() {

  local lang
  local str
  local f=0
  for lang in $(p6_echo "$P6_DFZ_PROMPT_LANG_LINES"); do
    if ! p6_word_in "$lang" "$P6_DFZ_PROMPT_LANG_LINES_OFF"; then
      local func="p6_${lang}_env_prompt_info"
      local cnt=$(p6_run_code "$func")
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

  p6_echo "$str"
}
