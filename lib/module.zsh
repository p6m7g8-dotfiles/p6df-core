p6df::core::module::init()     { local module="$1"; p6df::core::module::_recurse "$module" "init" }
p6df::core::module::vscodes()  { local module="$1"; p6df::core::module::_recurse "$module" "vscodes" }
p6df::core::module::langs()    { local module="$1"; p6df::core::module::_recurse "$module" "langs" }
p6df::core::module::brews()    { local module="$1"; p6df::core::module::_recurse "$module" "external::brew" }
p6df::core::module::symlinks() { local module="$1"; p6df::core::module::_recurse "$module" "home::symlinks" }

p6df::core::module::fetch()     { local module="$1"; p6df::core::module::_recurse "$module" "p6df::core::module::_fetch" }
p6df::core::module::update()    { local module="$1"; p6df::core::module::_recurse "$module" "p6df::core::module::_update" }

p6df::core::module::_fetch() {
  local dir="$1"
  local module="$2"

   if ! p6_dir_exists "$dir"; then
     p6_msg "gh repo clone $module $dir"
     p6_log "gh repo clone $module $dir"

     gh repo clone $module $dir
   fi
}

p6df::core::module::_update() {
  local dir="$1"
  local module="$2"

   if ! p6_dir_exists "$dir"; then
     p6df::core::module::_fetch "$dir" "$module"
   else
     p6_msg_no_nl "$dir: "
     p6_run_dir "$dir" "p6_git_p6_pull"
   fi
}

######################################################################
#<
#
# Function: p6df::core::module::add()
#
#  Environment:	 P6_DFZ_MODULES
#>
######################################################################
p6df::core::module::add() {
  local short_module="$1"

  local module=$(p6df::core::module::expand "$short_module")
  local things=$(p6_word_unique "$P6_DFZ_MODULES $module" | xargs)

  p6_env_export P6_DFZ_MODULES "$P6_DFZ_MODULES $module"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::use(short_module)
#
#  Args:
#	short_module -
#
#>
######################################################################
p6df::core::module::use() {
  local short_module="$1"

  local module=$(p6df::core::module::expand "$short_module")
  p6_log "p6df::core::module::use($short_module) -> $module"
  p6df::core::module::add "$short_module"
  p6df::core::module::init "$module"

  p6_return_void
}

# ---------------------------------------------------------------------------

######################################################################
#<
#
# Function: str module = p6df::core::module::expand(short_module)
#
#  Args:
#	short_module -
#
#  Returns:
#	str - module
#
#>
######################################################################
p6df::core::module::expand() {
  local short_module="$1"

  local module=$short_module
  case $short_module in
  p6common) module="p6m7g8-dotfiles/p6common" ;;
  p6df*) module="p6m7g8-dotfiles/$short_module" ;;
  esac

  p6_log "p6df::core::module::expand($short_module) -> $module"

  p6_return_str "$module"
}

######################################################################
#<
#
# Function: p6df::core::module::parse(module)
#
#  Args:
#	module -
#
#  Environment:	 XXX
#>
#/ Synopsis:
#/   Given a module as (organization/repository) return a hash/dict
#/   module="p6m7g8-dotfiles/p6df-js[:/path/to/dir]"
#/   dict = {
#/     repo:    p6df-js
#/     module:  js
#/     org:     p6m7g8-dotfiles
#/     path:    p6m7g8-dotfiles/p6df-js
#/     prefix:  p6df::modules::js
#/     [sub:     /path/to/dir]
#/     [plugin:  dir]
#/     version: master
#/     proto:   https
#/     host:    github.com
#/   }
######################################################################
p6df::core::module::parse() {
  local module="$1"

  declare -gA repo

  repo[repo]=${${module%%:*}##*/}            # org/(repo)
  repo[proto]=https                          # protocol
  repo[host]=github.com                      # XXX:
  repo[org]=${module%%/*}                    # (org)/repo
  repo[path]=$repo[org]/$repo[repo]          # (org/repo)
  repo[version]=master

  repo[module]=${repo[repo]##p6df-}          # p6df-(repo)
  repo[prefix]=p6df::modules::$repo[module]  # p6df::modules::(repo) without p6df-

  repo[sub]=${module##*:}                    # subdir file path : sep
  repo[plugin]=${repo[sub]##*/}              # subdir plugin up to first /

  if [[ $repo[repo] =~ ^p6 ]]; then
    repo[load_path]=$repo[path]/init.zsh
  elif [[ $repo[org] = ohmyzsh ]]; then
      if [[ $repo[sub] =~ lib ]]; then
        repo[load_path]=$repo[path]/$repo[sub].zsh
      else
        repo[load_path]=$repo[path]/$repo[sub]/$repo[plugin].plugin.zsh
      fi
  elif [[ $repo[repo] = prezto ]]; then
      repo[load_path]=$repo[path]/$repo[sub]/init.zsh
      repo[extra_load_path]=$repo[path]/init.zsh
  elif [[ $repo[repo] =~ wakatime-zsh-plugin ]]; then
	  repo[load_path]=$repo[path]/wakatime.plugin.zsh # grumble
  elif [[ $repo[repo] =~ zsh ]]; then
	  repo[load_path]=$repo[path]/$repo[plugin].plugin.zsh
  else
      repo[no_load]=1
  fi
}

######################################################################
#<
#
# Function: p6df::core::module::source(relpath, relaux)
#
#  Args:
#	relpath -
#	relaux -
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::core::module::source() {
  local relpath="$1"
  local relaux="$2"

  [[ -n "$relaux" ]] && p6df::core::file::load "$P6_DFZ_SRC_DIR/$relaux"
  p6df::core::file::load "$P6_DFZ_SRC_DIR/$relpath"
}

######################################################################
#<
#
# Function: str str = p6df::core::module::env::name(module)
#
#  Args:
#	module -
#
#  Returns:
#	str - str
#
#>
######################################################################
p6df::core::module::env::name() {
  local module="$1"

  local str=$(p6_echo $module | sed -e 's,[^A-Za-z0-9_],_,g')

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: p6df::core::module::_recurse(module, callback)
#
#  Args:
#	module -
#	callback -
#
#  Environment:	 EPOCHREALTIME P6_DFZ_SRC_DIR PL_ TOTAL
#>
######################################################################
p6df::core::module::_recurse() {
  local module="$1"
  local callback="$2"
  shift 2

  p6_log "=> p6df::core::module::_recurse($module, $callback)"

  # short circuit
  local breaker_var=$(p6df::core::module::env::name "P6_DFZ_env_${module}-${callback}")
  local breaker_val
  p6_run_code "breaker_val=\$${breaker_var}"

  if p6_string_eq "$breaker_val" "1"; then
    p6_log "short circuit"
 	return
  else
    p6_log "continue"
  fi
   p6_run_code "${breaker_var}=1"

  # load
  # %repo
  p6df::core::module::parse "$module"
  p6df::core::module::source "$repo[load_path]" "$repo[extra_load_path]"
  local main_repo=$repo[repo]
  local main_org=$repo[org]
  local main_module="$main_org/$main_repo"
  local main_prefix=$repo[prefix]
  unset repo

  # deps
  # @ModuleDeps
  unset ModuleDeps
  local func_deps="$main_prefix::deps"
  p6_run_if "$func_deps"

  local dep
  for dep in $ModuleDeps[@]; do
    p6_log "p6df::core::module::_recurse[dep]($dep, $callback)"
    p6df::core::module::_recurse "$dep" "$callback" "$@"
  done

  # relative to module or fully qualified callback
  local func_callback
  case $callback in
  *p6df::core::*) func_callback="$callback" ;;
  *) func_callback="$main_prefix::$callback"
  esac

  # tail recursive, do it at last
  p6_run_if "$func_callback" "$P6_DFZ_SRC_DIR/$main_org/$main_repo" "$main_org/$main_repo"

  p6_return_void
}
