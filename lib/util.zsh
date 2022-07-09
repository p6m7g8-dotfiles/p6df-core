######################################################################
#<
#
# Function: p6df::core::util::user::init()
#
#  Environment:	 HOME
#>
######################################################################
p6df::core::util::user::init() {

  p6df::core::util::file::load "$HOME/.zsh-me"
}

######################################################################
#<
#
# Function: p6df::core::util::file::load(file)
#
#  Args:
#	file -
#
#>
######################################################################
p6df::core::util::file::load() {
  local file="$1"

  if [[ -r "$file" ]]; then
    . "$file"
  fi
}

######################################################################
#<
#
# Function: p6df::core::util::exists(thing)
#
#  Args:
#	thing -
#
#  Depends:	 p6_log
#>
######################################################################
p6df::core::util::exists() {
  local thing="$1"

  type -f "$thing" >/dev/null 2>&1
}

######################################################################
#<
#
# Function: p6df::core::util::run::if(thing, ...)
#
#  Args:
#	thing -
#	... - 
#
#  Depends:	 p6_log
#>
######################################################################
p6df::core::util::run::if() {
  local thing="$1"
  shift 1

  p6df::core::util::exists "$thing" && p6df::core::util::run::code "$thing $@"
}

######################################################################
#<
#
# Function: p6df::core::util::run::code(thing, ...)
#
#  Args:
#	thing -
#	... - 
#
#  Depends:	 p6_log
#>
######################################################################
p6df::core::util::run::code() {
  local thing="$1"
  shift 1

  eval "$thing $@"
  if p6df::core::util::exists "p6_log"; then
    p6_log "p6df::core::util::run::code: $thing $@"
  fi
}

# XXX: rename path::if
######################################################################
#<
#
# Function: p6df::core::util::path_if()
#
#>
######################################################################
p6df::core::util::path_if() {

  p6df::core::util::path::if "$@"
}

######################################################################
#<
#
# Function: p6df::core::util::path::if(dir)
#
#  Args:
#	dir -
#
#>
######################################################################
p6df::core::util::path::if() {
  local dir="$1"

  if [[ -d "$dir" ]]; then
    path+=($dir)
  fi
}

######################################################################
#<
#
# Function: p6df::core::util::cdpath::if(dir)
#
#  Args:
#	dir -
#
#>
######################################################################
p6df::core::util::cdpath::if() {
  local dir="$1"

  if [[ -d "$dir" ]]; then
    cdpath+=($dir)
  fi
}
