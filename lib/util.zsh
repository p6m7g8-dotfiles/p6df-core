######################################################################
#<
#
# Function: p6df::util::user::init()
#
#  Environment:	 HOME
#>
######################################################################
p6df::util::user::init() {

  p6df::util::file::load "$HOME/.zsh-me"
}

######################################################################
#<
#
# Function: p6df::util::file::load(file)
#
#  Args:
#	file -
#
#>
######################################################################
p6df::util::file::load() {
  local file="$1"

  if [[ -r "$file" ]]; then
    . "$file"
  fi
}

######################################################################
#<
#
# Function: p6df::util::exists(thing)
#
#  Args:
#	thing -
#
#>
######################################################################
p6df::util::exists() {
  local thing="$1"

  type -f "$thing" >/dev/null 2>&1
}

######################################################################
#<
#
# Function: p6df::util::run::if(thing, ...)
#
#  Args:
#	thing -
#	... - 
#
#  Depends:	 p6_log
#>
######################################################################
p6df::util::run::if() {
  local thing="$1"
  shift 1

  p6df::util::exists "$thing" && p6df::util::run::code "$thing $@"
}

######################################################################
#<
#
# Function: p6df::util::run::code(thing, ...)
#
#  Args:
#	thing -
#	... - 
#
#  Depends:	 p6_log
#>
######################################################################
p6df::util::run::code() {
  local thing="$1"
  shift 1

  eval "$thing $@"
  if p6df::util::exists "p6_log"; then
    p6_log "p6df::util::run::code: $thing $@"
  fi
}

# XXX: rename path::if
######################################################################
#<
#
# Function: p6df::util::path_if()
#
#>
######################################################################
p6df::util::path_if() {

  p6df::util::path::if "$@"
}

######################################################################
#<
#
# Function: p6df::util::path::if(dir)
#
#  Args:
#	dir -
#
#>
######################################################################
p6df::util::path::if() {
  local dir="$1"

  if [[ -d "$dir" ]]; then
    path+=($dir)
  fi
}

######################################################################
#<
#
# Function: p6df::util::cdpath::if(dir)
#
#  Args:
#	dir -
#
#>
######################################################################
p6df::util::cdpath::if() {
  local dir="$1"

  if [[ -d "$dir" ]]; then
    cdpath+=($dir)
  fi
}
