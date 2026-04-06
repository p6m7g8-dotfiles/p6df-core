# shellcheck shell=bash


######################################################################
#<
#
# Function: str var_name = p6df::core::profile::secret::label(var_name)
#
#  Args:
#	var_name - strip leading $
#
#  Returns:
#	str - var_name
#	str - [sdk]
#
#>
######################################################################
p6df::core::profile::secret::label() {
  local var_name="${1#\$}"       # strip leading $
  var_name="${var_name#\{}"      # strip leading {
  var_name="${var_name%\}}"      # strip trailing }
  var_name="${var_name:u}"       # uppercase

  case "$var_name" in
    *_TOKEN*|*_SECRET*|*_PASSWORD*|*_PASSWD*|*_PASS|*_API_KEY*|*_AUTH_TOKEN*|*_BEARER*|*_PRIVATE_KEY*|*_ACCESS_KEY*)
      p6_return_str "$var_name" ;;
    *_SDK*)
      p6_return_str "[sdk]" ;;
    *)
      p6_return_void ;;
  esac
}

######################################################################
#<
#
# Function: str str = p6df::core::profile::default::mod([label=], ...)
#
#  Args:
#	OPTIONAL label - []
#	... - 
#
#  Returns:
#	str - str
#
#>
######################################################################
p6df::core::profile::default::mod() {
  local label="${1:-}"
  shift

  local -a values
  local fmt
  for fmt in "$@"; do
    local value="${(e)fmt}"
    if p6_string_blank_NOT "$value"; then
      local redacted=$(p6df::core::profile::secret::label "$fmt")
      if p6_string_blank_NOT "$redacted"; then
        values+=("$redacted")
      else
        values+=("$value")
      fi
    fi
  done

  local str
  if [[ ${#values} -gt 0 ]]; then
    str="$(p6_string_space_pad "${label}:" 16)${(j: :)values}"
  fi

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: str str = p6df::core::profile::module::mod(module)
#
#  Args:
#	module -
#
#  Returns:
#	str - str
#
#>
######################################################################
p6df::core::profile::module::mod() {
  local module="$1"

  # %repo
  p6df::core::module::parse "$module"
  local profile_mod_func=$repo[profile_mod]
  unset repo

  local label
  local -a fmts
  if type -f "$profile_mod_func" >/dev/null 2>&1; then
    local -a parts
    parts=("${(z)$("$profile_mod_func")}")
    label="${parts[1]}"
    fmts=("${parts[2,-1]}")
  fi

  local str=$(p6df::core::profile::default::mod "$label" "${fmts[@]}")

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: p6df::core::profile::default::on(code)
#
#  Args:
#	code -
#
#>
######################################################################
p6df::core::profile::default::on() {
  local code="$1"

  if p6_string_ne "$code" "null"; then
    p6_run_code "$code"
  fi

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::profile::default::off(code)
#
#  Args:
#	code -
#
#>
######################################################################
p6df::core::profile::default::off() {
  local code="$1"

  p6_env_unset_from_code "$code"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::profile::module::on(module, profile, code)
#
#  Args:
#	module -
#	profile -
#	code -
#
#>
######################################################################
p6df::core::profile::module::on() {
  local module="$1"
  local profile="$2"
  local code="$3"

  # %repo
  p6df::core::module::parse "$module"
  local profile_on_func=$repo[profile_on]
  unset repo

  if type -f "$profile_on_func" >/dev/null 2>&1; then
    "$profile_on_func" "$profile" "$code"
  else
    p6df::core::profile::default::on "$code"
  fi

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::profile::module::active(module, profile)
#
#  Args:
#	module -
#	profile -
#
#  Environment:	 OP_VAULT_NAME
#>
######################################################################
p6df::core::profile::module::active() {
  local module="$1"
  local profile="$2"

  local short="${module##*/p6df-}"
  local env=$(op item get "P6/DFZ/${short}/env" --vault "$OP_VAULT_NAME" --field notesPlain --format json | jq -r '.value')
  p6df::core::profile::module::on "$module" "$profile" "$env"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::profile::module::off(module, code)
#
#  Args:
#	module -
#	code -
#
#>
######################################################################
p6df::core::profile::module::off() {
  local module="$1"
  local code="$2"

  # %repo
  p6df::core::module::parse "$module"
  local profile_off_func=$repo[profile_off]
  unset repo

  if type -f "$profile_off_func" >/dev/null 2>&1; then
    "$profile_off_func" "$code"
  else
    p6df::core::profile::default::off "$code"
  fi

  p6_return_void
}
