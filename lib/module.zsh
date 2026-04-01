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
# Function: p6df::core::module::init(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::init() {
  local module="$1"
  local dir="$2"

  p6df::core::bootstrap::module::init "$module" "$dir"      # Bootstrap

  p6df::core::internal::recurse "$module" "$dir" "init"

  # After 'Tail-recursion' also run api hooks
  p6df::core::env::module::init "$module" "$dir"            # Env
  p6df::core::path::module::init "$module" "$dir"           # Path
  p6df::core::cdpath::module::init "$module" "$dir"         # CDPath
  p6df::core::fpath::module::init "$module" "$dir"          # FPath
  p6df::core::completions::module::init "$module" "$dir"    # Completions
  p6df::core::aliases::module::init "$module" "$dir"        # Aliases
  p6df::core::langmgr::module::init "$module" "$dir"        # LangMgr
  p6df::core::prompt::module::init "$module" "$dir"         # Prompt

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
# Function: p6df::core::module::mcp(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::mcp() {
  local module="$1"
  local dir="$2"

  p6df::core::internal::recurse "$module" "$dir" "mcp"

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

   p6df::core::internal::recurse "$module" "$dir" "external::brews"

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

  p6df::core::module::pull "$module" "$dir"
  p6df::core::module::push "$module" "$dir"

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
# Function: p6df::core::module::add(module, _dir)
#
#  Args:
#	module -
#	_dir -
#
#  Environment:	 P6_DFZ_MODULES
#>
######################################################################
p6df::core::module::add() {
  local module="$1"
  local _dir="$2"

  local things=$(p6_word_unique "$P6_DFZ_MODULES $module" | p6_filter_join_words)

  p6_env_export P6_DFZ_MODULES "$things"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::module::add::lazy(module, _dir)
#
#  Args:
#	module -
#	_dir -
#
#  Environment:	 P6_DFZ_MODULES
#>
######################################################################
p6df::core::module::add::lazy() {
  local module="$1"
  local _dir="$2"

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

  local things=$(p6_word_unique "$P6_DFZ_MODULES" | p6_filter_join_words)

  p6_env_export P6_DFZ_MODULES "$things"

  p6_return_void
}
######################################################################
#<
#
# Function: p6df::core::module::use(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::core::module::use() {
  local module="$1"
  local dir="$2"

  p6df::core::module::add "$module"
  p6df::core::module::init "$module" "$dir"

  p6_return_void
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
  repo[prompt_mod_bottom]=$repo[prefix]::prompt::mod::bottom # prompt mod bottom function
  repo[prompt_runtime]=$repo[prefix]::prompt::runtime  # prompt runtime function
  repo[prompt_context]=$repo[prefix]::prompt::context  # prompt context function
  repo[prompt_system]=$repo[prefix]::prompt::system    # prompt system function
  repo[prompt_env]=$repo[prefix]::prompt::env         # prompt env function
  repo[prompt_lang]=$repo[prefix]::prompt::lang       # prompt lang function
  repo[env_init]=$repo[prefix]::env::init              # env function
  repo[alias]=$repo[prefix]::aliases::init            # alias function
  repo[skills_init]=$repo[prefix]::skills::init       # skills function
  repo[path_init]=$repo[prefix]::path::init           # path function
  repo[cdpath_init]=$repo[prefix]::cdpath::init       # cdpath function
  repo[fpath_init]=$repo[prefix]::fpath::init         # fpath function
  repo[completion]=$repo[prefix]::completions::init   # completion function
  repo[langmgr_init]=$repo[prefix]::langmgr::init     # langmgr function
  repo[prompt_init]=$repo[prefix]::prompt::init        # prompt init function
  repo[profile_on]=$repo[prefix]::profile::on          # profile on function
  repo[profile_off]=$repo[prefix]::profile::off        # profile off function
  repo[profile_mod]=$repo[prefix]::profile::mod        # profile mod function

  repo[sub]=${module##*:}                    # subdir file path : sep
  repo[plugin]=${repo[sub]##*/}              # subdir plugin up to first /

  if p6_string_match_regex "${repo[repo]}" '^p6-'; then
    repo[load_path]=$repo[path]/$repo[repo].zsh
    repo[load_path]="${repo[load_path]/-plugin.zsh/.plugin.zsh}"
  elif p6_string_match_regex "${repo[repo]}" '^p6'; then
    repo[load_path]=$repo[path]/init.zsh
  elif p6_string_eq "${repo[org]}" "ohmyzsh"; then
      if p6_string_match_regex "${repo[sub]}" 'lib'; then
        repo[load_path]=$repo[path]/$repo[sub].zsh
      else
        repo[load_path]=$repo[path]/$repo[sub]/$repo[plugin].plugin.zsh
      fi
  elif p6_string_match_regex "${repo[repo]}" 'zsh'; then
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

  local str=$(p6_string_sanitize_identifier "${module}-${callback}")

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: p6df::core::bootstrap::module::init(module, _dir)
#
#  Args:
#	module -
#	_dir -
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::core::bootstrap::module::init() {
  local module="$1"
  local _dir="$2"

  # %repo
  p6df::core::module::parse "$module"
  local module_dir="$P6_DFZ_SRC_DIR/$repo[path]"
  unset repo

  if [[ -d "$module_dir/lib" ]]; then
    p6_bootstrap "$module_dir"
  fi

  p6_return_void
}
