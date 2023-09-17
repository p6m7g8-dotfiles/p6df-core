# shellcheck shell=zsh

######################################################################
#<
#
# Function: p6df::core::dev::graph()
#
#  Environment:	 DIR EOF P6_DFZ_MODULES
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
    p6df::core::internal::recurse "$module" "DIR" "p6df::core::dev::dot"
  done

  p6_echo "}"
}

######################################################################
#<
#
# Function: p6df::core::dev::dot(module, dep)
#
#  Args:
#	module -
#	dep -
#
#>
######################################################################
p6df::core::dev::dot() {
  local module="$1"
  local dep="$2"

  module=$(p6_echo $module | sed -e 's,[:\./-],_,g')
  dep=$(p6_echo $dep | sed -e 's,[:\./-],_,g')

  p6_echo "$module -> $dep;"
}
