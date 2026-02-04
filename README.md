# P6's POSIX.2: p6df-core

## Table of Contents

- [Badges](#badges)
- [Summary](#summary)
- [Contributing](#contributing)
- [Code of Conduct](#code-of-conduct)
- [Usage](#usage)
  - [Functions](#functions)
- [Hierarchy](#hierarchy)
- [Author](#author)

## Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)

## Summary

TODO: Add a short summary of this module.

## Contributing

- [How to Contribute](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CONTRIBUTING.md>)

## Code of Conduct

- [Code of Conduct](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CODE_OF_CONDUCT.md>)

## Usage

### Functions

#### p6df-core/lib

##### p6df-core/lib/_bootstrap.zsh

- `p6df::core::_bootstrap()`

##### p6df-core/lib/aliases.zsh

- `p6df::core::aliases::init()`
- `p6df::core::aliases::module::init(module, dir)`
  - Args:
    - module - 
    - dir - 

##### p6df-core/lib/cli.zsh

- `p6df::core::cli::all(cmd, ...)`
  - Args:
    - cmd - 
    - ... - 
- `p6df::core::cli::all::run(dir, cmd)`
  - Args:
    - dir - 
    - cmd - 
- `p6df::core::cli::run(...)`
  - Args:
    - ... - 
- `p6df::core::cli::usage([rc=0], [msg=])`
  - Synopsis: bin/p6df [-D|-d] [cmd]
  - Args:
    - OPTIONAL rc - [0]
    - OPTIONAL msg - []

##### p6df-core/lib/completions.zsh

- `p6df::core::completions::module::init(module, dir)`
  - Args:
    - module - 
    - dir - 

##### p6df-core/lib/dev.zsh

- `p6df::core::dev::dot(module, dep)`
  - Args:
    - module - 
    - dep - 
- `p6df::core::dev::graph([modules=$P6_DFZ_MODULES])`
  - Args:
    - OPTIONAL modules - [$P6_DFZ_MODULES]

##### p6df-core/lib/file.zsh

- `p6df::core::file::load(file)`
  - Args:
    - file - 

##### p6df-core/lib/homebrew.zsh

- `p6df::core::homebrew::brews::remove()`
- `p6df::core::homebrew::casks::remove()`
- `p6df::core::homebrew::cli::brew::install(...)`
  - Args:
    - ... - 
- `p6df::core::homebrew::cli::brew::services::start(...)`
  - Args:
    - ... - 
- `p6df::core::homebrew::cli::brew::services::stop(...)`
  - Args:
    - ... - 
- `p6df::core::homebrew::cmd::brew(...)`
  - Args:
    - ... - 
- `p6df::core::homebrew::init()`
  - Synopsis: Warning: Using vim because no editor was set in the environment. This may change in the future, so we recommend setting EDITOR, or HOMEBREW_EDITOR to your preferred text editor.
- `p6df::core::homebrew::install()`
- `p6df::core::homebrew::nuke()`
- `p6df::core::homebrew::remove()`

##### p6df-core/lib/internal.zsh

- `p6df::core::internal::branch(_module, dir)`
  - Args:
    - _module - 
    - dir - 
- `p6df::core::internal::debug(msg)`
  - Args:
    - msg - 
- `p6df::core::internal::diag(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::internal::diff(_module, dir)`
  - Args:
    - _module - 
    - dir - 
- `p6df::core::internal::doc(_module, dir)`
  - Args:
    - _module - 
    - dir - 
- `p6df::core::internal::fetch(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::internal::langs(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::internal::pull(_module, dir)`
  - Args:
    - _module - 
    - dir - 
- `p6df::core::internal::push(_module, dir)`
  - Args:
    - _module - 
    - dir - 
- `p6df::core::internal::recurse(module, dir, [callback=], ...)`
  - Args:
    - module - 
    - dir - 
    - OPTIONAL callback - []
    - ... - 
- `p6df::core::internal::recurse::deps::each(dir, callback, ...)`
  - Args:
    - dir - 
    - callback - 
    - ... - 
- `p6df::core::internal::recurse::deps::run(module, func_deps, callback)`
  - Args:
    - module - 
    - func_deps - 
    - callback - 
- `p6df::core::internal::recurse::shortcircuit(module, dir, callback)`
  - Args:
    - module - 
    - dir - 
    - callback - 
- `p6df::core::internal::status(_module, dir)`
  - Args:
    - _module - 
    - dir - 
- `p6df::core::internal::update(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::internal::vscodes(module, dir)`
  - Args:
    - module - 
    - dir - 
- `str func_callback = p6df::core::internal::recurse::callback(callback, prefix)`
  - Args:
    - callback - 
    - prefix - 

##### p6df-core/lib/lang.zsh

- `p6df::core::lang::mgr::init(dir, name)`
  - Args:
    - dir - 
    - name - 
- `str label:$ver = p6df::core::lang::prompt::lang(label, mgr_cmd, sys_cmd)`
  - Args:
    - label - 
    - mgr_cmd - 
    - sys_cmd - 

##### p6df-core/lib/main.zsh

- `p6df::core::main::init()`
- `p6df::core::main::self::init()`
- `p6df::core::timing::init()`

##### p6df-core/lib/module.zsh

- `p6df::core::module::add(short_module, _dir)`
  - Args:
    - short_module - 
    - _dir - 
- `p6df::core::module::add::export()`
- `p6df::core::module::add::lazy(short_module, _dir)`
  - Args:
    - short_module - 
    - _dir - 
- `p6df::core::module::brews(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::module::diag(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::module::diff(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::module::doc(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::module::fetch(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::module::init(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::module::langs(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::module::parse(module, _dir)`
  - Synopsis: Given a module as (organization/repository) return a hash/dict module="p6m7g8-dotfiles/p6df-js[:/path/to/dir]" dict = { repo:    p6df-js module:  js org:     p6m7g8-dotfiles path:    p6m7g8-dotfiles/p6df-js prefix:  p6df::modules::js [sub:     /path/to/dir] [plugin:  dir] version: master proto:   https host:    github.com }
  - Args:
    - module - 
    - _dir - 
- `p6df::core::module::pull(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::module::push(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::module::status(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::module::symlinks(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::module::sync(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::module::update(module, dir)`
  - Args:
    - module - 
    - dir - 
- `p6df::core::module::use(short_module, dir)`
  - Args:
    - short_module - 
    - dir - 
- `p6df::core::module::vscodes(module, dir)`
  - Args:
    - module - 
    - dir - 
- `str module = p6df::core::module::expand(short_module, _dir)`
  - Args:
    - short_module - 
    - _dir - 
- `str str = p6df::core::module::env::name(module, _dir, callback)`
  - Args:
    - module - 
    - _dir - 
    - callback - 

##### p6df-core/lib/modules.zsh

- `p6df::core::modules::bootstrap::p6common([dir=$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6common])`
  - Args:
    - OPTIONAL dir - [$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6common]
- `p6df::core::modules::brews()`
- `p6df::core::modules::foreach(callback)`
  - Args:
    - callback - 
- `p6df::core::modules::init()`
- `p6df::core::modules::langs()`
- `p6df::core::modules::load()`
- `p6df::core::modules::symlinks()`
- `p6df::core::modules::vscodes()`

##### p6df-core/lib/path.zsh

- `p6df::core::path::cd::if(dir)`
  - Args:
    - dir - 
- `p6df::core::path::cd::init()`
- `p6df::core::path::if(dir)`
  - Args:
    - dir - 
- `p6df::core::path::init(dir)`
  - Args:
    - dir - 
- `p6df::core::path::module::init(module)`
  - Args:
    - module - 

##### p6df-core/lib/profile.zsh

- `str str = p6df::core::profile::prompt::mod()`

##### p6df-core/lib/prompt.zsh

- `p6df::core::prompt::init()`
- `p6df::core::prompt::line::add::env(func)`
  - Args:
    - func - 
- `p6df::core::prompt::line::add::lang(func)`
  - Args:
    - func - 
- `p6df::core::prompt::line::add::mod(func)`
  - Args:
    - func - 
- `p6df::core::prompt::line::add::mod::bottom(func)`
  - Args:
    - func - 
- `p6df::core::prompt::module::init(module)`
  - Args:
    - module - 
- `str cnt = p6df::core::prompt::runtime::line(func)`
  - Args:
    - func - 
- `stream  = p6df::core::prompt::runtime()`
- `stream  = p6df::core::prompt::runtime::lines()`

##### p6df-core/lib/theme.zsh

- `p6df::core::theme::init()`

##### p6df-core/lib/user.zsh

- `p6df::core::user::init()`

## Hierarchy

```text
.
├── bin
│   └── p6df
├── conf
│   ├── zsh-me
│   ├── zshenv
│   ├── zshenv-xdg
│   └── zshrc
├── doc
│   ├── flow.md
│   └── hook_api.md
├── lib
│   ├── _bootstrap.zsh
│   ├── aliases.zsh
│   ├── cli.zsh
│   ├── completions.zsh
│   ├── dev.zsh
│   ├── file.zsh
│   ├── homebrew.zsh
│   ├── internal.zsh
│   ├── lang.zsh
│   ├── main.zsh
│   ├── module.zsh
│   ├── modules.zsh
│   ├── path.zsh
│   ├── profile.zsh
│   ├── prompt.zsh
│   ├── theme.zsh
│   └── user.zsh
├── README.md
├── share
└── t
    └── cli.sh

7 directories, 26 files
```

## Author

Philip M. Gollucci <pgollucci@p6m7g8.com>
