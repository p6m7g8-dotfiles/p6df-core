######################################################################
#<
#
# Function: p6df::core::module::add(short_module)
#
#  Args:
#	short_module -
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
  else
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
# Function: str P6_env_${str} = p6df::core::module::env::name(module)
#
#  Args:
#	module -
#
#  Returns:
#	str - P6_env_${str}
#
#  Environment:	 P6_
#>
######################################################################
p6df::core::module::env::name() {
	local module="$1"

	local str=$(p6_echo $module | sed -e 's,[^A-Za-z0-9_],_,g')

	p6_return_str "P6_env_${str}"
}

######################################################################
#<
#
# Function: p6df::core::module::load(module)
#
#  Args:
#	module -
#
#  Environment:	 EPOCHREALTIME P6_DFZ_SRC_DIR TOTAL
#>
######################################################################
p6df::core::module::load()     { local module="$1"; p6df::core::module::_recurse "$module" "init" }
p6df::core::module::vscodes()  { local module="$1"; p6df::core::module::_recurse "$module" "vscodes" }
p6df::core::module::langs()    { local module="$1"; p6df::core::module::_recurse "$module" "langs" }
p6df::core::module::brews()    { local module="$1"; p6df::core::module::_recurse "$module" "external::brew" }
p6df::core::module::symlinks() { local module="$1"; p6df::core::module::_recurse "$module" "home::symlinks" }

p6df::core::module::_recurse() {
	local module="$1"
    local callback="$2"

    local t0=$EPOCHREALTIME
	local env_name=$(p6df::core::module::env::name "$module")
    local env_callback=$(p6df::core::module::env::name "$callback")

	local val
	p6_run_code "val=\$${env_name}__${env_callback}"

	if ! p6_string_blank "$val"; then
		return
	fi

	# %repo
	unset repo
	p6df::core::module::parse "$module"
	p6df::core::module::source "$repo[load_path]" "$repo[extra_load_path]"

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
#	    local t2=$EPOCHREALTIME
		p6df::core::module::load "$dep"
#	    local t3=$EPOCHREALTIME
#    	p6_time "$t2" "$t3" "===> p6df::core::module::load($dep)"
	done
    unset ModuleDeps

	local func_init="$orig_prefix::$callback"
	__p6_dir=$P6_DFZ_SRC_DIR/$module p6_run_if "$func_init"

	unset repo
    eval "${env_name}__${env_callback}=1"

	local t1=$EPOCHREALTIME
	p6_time "$t0" "$t1" "TOTAL: p6df::core::module::load($module)"

	p6_return_void
}