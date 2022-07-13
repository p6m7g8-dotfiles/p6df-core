p6df::core::module::load()     { local module="$1"; p6df::core::module::_recurse "$module" "init" }
p6df::core::module::vscodes()  { local module="$1"; p6df::core::module::_recurse "$module" "vscodes" }
p6df::core::module::langs()    { local module="$1"; p6df::core::module::_recurse "$module" "langs" }
p6df::core::module::brews()    { local module="$1"; p6df::core::module::_recurse "$module" "external::brew" }
p6df::core::module::symlinks() { local module="$1"; p6df::core::module::_recurse "$module" "home::symlinks" }

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
	p6df::core::module::load "$module"

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

    local t0=$EPOCHREALTIME                                                             # Start Timer
	local breaker_var=$(p6df::core::module::env::name "PL_env_${module}-${callback}")   # Transliterate to a sh variable name

	local breaker_val
	p6_run_code "breaker_val=\$${breaker_var}"                                                   # val is the vaalue of this module's variable

	if p6_string_eq "$breaker_val" "1"; then
	  p6_log "short circuit"
 	  return
	else
	  p6_log "continue"
	fi

	# %repo
	unset repo
	p6df::core::module::parse "$module"
	p6df::core::module::source "$repo[load_path]" "$repo[extra_load_path]"

    p6_run_code "${breaker_var}=1"

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
		p6_log "$module -> $dep"
	    local t2=$EPOCHREALTIME
		p6df::core::module::load "$dep"
	    local t3=$EPOCHREALTIME
    	p6_time "$t2" "$t3" "===> p6df::core::module::load[dep]($dep)"
	done
    unset ModuleDeps

	local func_callback="$orig_prefix::$callback"
	__p6_dir=$P6_DFZ_SRC_DIR/$module p6_run_if "$func_callback"

	unset repo

	local t1=$EPOCHREALTIME
	p6_time "$t0" "$t1" "TOTAL: p6df::core::module::load($module)"

	p6_log ""
	p6_return_void
}
