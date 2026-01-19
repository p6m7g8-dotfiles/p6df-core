# shellcheck shell=bash

# -------------------------------------------------------------------
#
# p6df::core::module::$cmd $module
#    can be called as
# p6df $cmd $module
#
#  p6df::core::module::$cmd($module, $dir)
#    p6df::modules::$module::init($module, $dir)
#
# --------------------------------------------------------------------

######################################################################
#<
#
# Function: p6df::core::module::init()
#
#>
######################################################################
p6df::core::module::init() {
  local module="$1"
  local dir="$2"

  p6df::core::internal::recurse "$module" "$dir" "init"

  # After 'Tail-recursion' also run api hooks
  p6df::core::prompt::module::init "$module" "$dir"         # Prompt
  p6df::core::aliases::module::init "$module" "$dir"        # Aliases
  p6df::core::completions::module::init "$module" "$dir"    # Completions

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::vscodes(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::vscodes() {
  local module="$1"
  local dir="$2"

  p6df::core::internal::recurse "$module" "$dir" "vscodes"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::langs(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::langs() {
  local module="$1"
  local dir="$2"

  p6df::core::internal::recurse "$module" "$dir" "langs"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::brews(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::brews() {
   local module="$1"
   local dir="$2"

   p6df::core::internal::recurse "$module" "$dir" "external::brew"

   p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::symlinks(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::symlinks() {
  local module="$1"
  local dir="$2"

  p6df::core::internal::recurse "$module" "$dir" "home::symlinks"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::fetch(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::fetch() {
  local module="$1"
  local dir="$2"

  p6df::core::internal::recurse "$module" "$dir" "p6df::core::internal::fetch"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::update(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::update() {
  local module="$1"
  local dir="$2"

  p6df::core::internal::recurse "$module" "$dir" "p6df::core::internal::update"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::status(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::status() {
  local module="$1"
  local dir="$2"

  p6df::core::internal::recurse "$module" "$dir" "p6df::core::internal::status"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::diff(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::diff() {
  local module="$1"
  local dir="$2"

  p6df::core::internal::recurse "$module" "$dir" "p6df::core::internal::diff"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::pull(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::pull() {
  local module="$1"
  local dir="$2"

  p6df::core::internal::recurse "$module" "$dir" "p6df::core::internal::pull"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::push(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::push() {
  local module="$1"
  local dir="$2"

  p6df::core::internal::recurse "$module" "$dir" "p6df::core::internal::push"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::diag(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::diag() {
  local module="$1"
  local dir="$2"

  p6df::core::internal::recurse "$module" "$dir" "p6df::core::internal::diag"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::sync(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::sync() {
  local module="$1"
  local dir="$2"

   p6df::core::module::pull
   p6df::core::module::push

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::doc(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::doc() {
  local module="$1"
  local dir="$2"

  p6df::core::module::use "p6m7g8-dotfiles/p6df-perl"
  p6df::core::internal::doc "$module" "$dir"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::add(short_module, _dir)
#
#  Args:
#	short_module -
#	_dir -
#
#  Environment:	 P6_DFZ_MODULES
#>
######################################################################
p6df::core::module::add() {
  local short_module="$1"
  local _dir="$2"

  local module=$(p6df::core::module::expand "$short_module")
  local things=$(p6_word_unique "$P6_DFZ_MODULES $module" | xargs)

  p6_env_export P6_DFZ_MODULES "$things"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::add::lazy(short_module, _dir)
#
#  Args:
#	short_module -
#	_dir -
#
#  Environment:	 P6_DFZ_MODULES
#>
######################################################################
p6df::core::module::add::lazy() {
  local short_module="$1"
  local _dir="$2"

  local module=$(p6df::core::module::expand "$short_module")

  P6_DFZ_MODULES="$P6_DFZ_MODULES $module"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::add::export()
#
#  Environment:	 P6_DFZ_MODULES
#>
######################################################################
p6df::core::module::add::export() {

  local things=$(p6_word_unique "$P6_DFZ_MODULES" | xargs)

  p6_env_export P6_DFZ_MODULES "$things"

  p6_return_void
}
######################################################################
#<
#
# Function: p6df::core::module::use(short_module, dir)
#
#  Args:
#	short_module -
#	dir -
#
#>
######################################################################
p6df::core::module::use() {
  local short_module="$1"
  local dir="$2"

  local module=$(p6df::core::module::expand "$short_module")
  p6_log "p6df::core::module::use($short_module) -> $module"
  p6df::core::module::add "$short_module"
  p6df::core::module::init "$module" "$dir"

  p6_return_void
}

######################################################################
#<
#
# Function: str module = p6df::core::module::expand(short_module, _dir)
#
#  Args:
#	short_module -
#	_dir -
#
#  Returns:
#	str - module
#
#>
######################################################################
p6df::core::module::expand() {
  local short_module="$1"
  local _dir="$2"

  local module=$short_module
  case $short_module in
  *p6m7g8-dotfiles*) module=$short_module ;;
  p6df*) module="p6m7g8-dotfiles/$short_module" ;;
  p6-*) module=p6m7g8/$short_module ;;
  p6*) module="p6m7g8-dotfiles/$short_module" ;;
  esac

  p6df::core::internal::debug  "p6df::core::module::expand($short_module) -> $module"

  p6_return_str "$module"
}

######################################################################
#<
#
# Function: p6df::core::module::parse(module, _dir)
#
#  Args:
#	module -
#	_dir -
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
  local _dir="$2"

  declare -gA repo

  repo[repo]=${${module%%:*}##*/}            # org/(repo)
  repo[proto]=https                        # protocol
  repo[host]=github.com                      # XXX:
  repo[org]=${module%%/*}                    # (org)/repo
  repo[path]=$repo[org]/$repo[repo]          # (org/repo)
  repo[version]=master

  repo[module]=${repo[repo]##p6df-}                   # p6df-(repo)
#  repo[module]=${repo[module]##p6}                   # p6(repo)
  repo[prefix]=p6df::modules::$repo[module]           # p6df::modules::(repo) without p6df-
  repo[prompt_mod]=$repo[prefix]::prompt::mod         # prompt module function
  repo[prompt_env]=$repo[prefix]::prompt::env         # prompt env function
  repo[prompt_lang]=$repo[prefix]::prompt::lang       # prompt lang function
  repo[alias]=$repo[prefix]::aliases::init            # alias function
  repo[completion]=$repo[prefix]::completions::init   # completion function

  repo[sub]=${module##*:}                    # subdir file path : sep
  repo[plugin]=${repo[sub]##*/}              # subdir plugin up to first /

  if [[ $repo[repo] =~ ^p6- ]]; then
    repo[load_path]=$repo[path]/$repo[repo].zsh
    repo[load_path]="${repo[load_path]/-plugin.zsh/.plugin.zsh}"
  elif [[ $repo[repo] =~ ^p6 ]]; then
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
  elif [[ $repo[repo] =~ zsh ]]; then
	  repo[load_path]=$repo[path]/$repo[plugin].plugin.zsh
  else
      repo[no_load]=1
  fi

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::core::module::env::name(module, _dir, callback)
#
#  Args:
#	module -
#	_dir -
#	callback -
#
#  Returns:
#	str - str
#
#>
######################################################################
p6df::core::module::env::name() {
  local module="$1"
  local _dir="$2"
  local callback="$3"

  local str=$(p6_echo "${module}-${callback}" | sed -e 's,[^A-Za-z0-9_],_,g')

  p6_return_str "$str"
}
