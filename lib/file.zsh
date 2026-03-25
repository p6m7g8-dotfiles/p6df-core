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
    echo "p6df-core . $file" >>/tmp/p6/log.log
    . "$file"
  else
    true
    echo "p6df::core::file::load($file): does not exist" >>/tmp/p6/log.log
  fi
}
