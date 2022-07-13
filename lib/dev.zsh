# shellcheck shell=zsh

######################################################################
#<
#
# Function: p6df::core::dev::graph()
#
#  Environment:	 EOF P6_DFZ_MODULES
#>
######################################################################
p6df::core::dev::graph() {
  local modules="${1:-$P6_DFZ_MODULES}"

  cat <<EOF
digraph p6m7g8_dotfiles {
 rankdir=LR;
# size="11,8.5";
# layout=neato;
# overlap=false;
# splines=true;
# pack=true;
# start="random";
# sep=0.1;
# edge [len=2];
# node[shape=oval,style=filled,fillcolor="#FFFFFF"];
EOF

  local module
  for module in $(p6_vertical "$modules"); do
    p6df::core::dev::_recurse "$module" "_dot"
  done

  p6_echo "}"
}

######################################################################
#<
#
# Function: p6df::core::dev::_recurse(module, callback, module, dep)
#
#  Args:
#	module -
#	callback -
#	module -
#	dep -
#
#  Environment:	 XXX
#>
######################################################################
p6df::core::dev::_recurse() {
  local module="$1"
  local callback="$2"

  # %repo
  unset repo
  p6df::core::module::parse "$module"
  p6df::core::module::source "$repo[load_path]" "$repo[extra_load_path]"

  # Non p6 modules don't have deps
  case $module in
  */p6*) ;;
  *) return ;;
  esac

  # @ModuleDeps
  unset ModuleDeps
  local orig_prefix=$repo[prefix]
  local func_deps="$orig_prefix::deps"
  p6_run_if "$func_deps"

  local dep
  for dep in $ModuleDeps[@]; do
    _dot "$module" "$dep" # XXX: callback
    p6df::core::dev::_recurse "$dep" "$callback"
  done
  unset ModuleDeps
  unset repo

  p6_return_void
}

_dot() {
  local module="$1"
  local dep="$2"

  module=$(p6_echo $module | sed -e 's,[:\./-],_,g')
  dep=$(p6_echo $dep | sed -e 's,[:\./-],_,g')

  p6_echo "$module -> $dep;"
}
