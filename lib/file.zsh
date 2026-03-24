######################################################################
#<
#
# Function: p6df::core::file::load(file)
#
#  Args:
#	file -
#
#>
######################################################################
p6df::core::file::load() {
  local file="$1"

  if [[ -r "$file" ]]; then
    p6_msg "p6df-core . $file"
    . "$file"
  else
    true
    p6_error "p6df::core::file::load($file): does not exist"
  fi
}
