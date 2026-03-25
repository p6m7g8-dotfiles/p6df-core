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
    echo "p6df-core . $file"
    . "$file"
  else
    true
    echo "p6df::core::file::load($file): does not exist" >&2
  fi
}
