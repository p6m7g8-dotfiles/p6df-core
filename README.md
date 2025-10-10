# P6's POSIX.2: p6df-core

## Table of Contents

## Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![Mergify](https://img.shields.io/endpoint.svg?url=https://gh.mergify.io/badges//p6df-core/&style=flat)](https://mergify.io)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](<https://gitpod.io/#https://github.com//p6df-core>)

## Summary

## Contributing

- [How to Contribute](<https://github.com//.github/blob/main/CONTRIBUTING.md>)

## Code of Conduct

- [Code of Conduct](<https://github.com//.github/blob/main/CODE_OF_CONDUCT.md>)

## Usage

### Aliases

### Functions

## p6df-core/lib

### p6df-core/lib/_bootstrap.zsh

- p6df::core::_bootstrap()

### p6df-core/lib/aliases.zsh

- p6df::core::aliases::init()
- p6df::core::aliases::module::init(module)

### p6df-core/lib/cli.zsh

- p6df::core::cli::all(cmd, ...)
- p6df::core::cli::all::run(dir)
- p6df::core::cli::run(...)
- p6df::core::cli::usage([rc=0], [msg=])

### p6df-core/lib/completions.zsh

- p6df::core::completions::module::init()

### p6df-core/lib/dev.zsh

- p6df::core::dev::dot(module, dep)
- p6df::core::dev::graph()

### p6df-core/lib/file.zsh

- p6df::core::file::load(file)

### p6df-core/lib/homebrew.zsh

- p6df::core::homebrew::brews::remove()
- p6df::core::homebrew::casks::remove()
- p6df::core::homebrew::init()
- p6df::core::homebrew::install()
- p6df::core::homebrew::nuke()

### p6df-core/lib/internal.zsh

- p6df::core::internal::branch(_module, dir)
- p6df::core::internal::debug(msg)
- p6df::core::internal::diag(module, dir)
- p6df::core::internal::diff(_module, dir)
- p6df::core::internal::doc(_module, dir)
- p6df::core::internal::fetch()
- p6df::core::internal::langs(module, dir)
- p6df::core::internal::pull(_module, dir)
- p6df::core::internal::push(_module, dir)
- p6df::core::internal::recurse(module, dir, [callback=], ...)
- p6df::core::internal::recurse::deps::each(dir, callback, ...)
- p6df::core::internal::recurse::deps::run(module, func_deps, callback)
- p6df::core::internal::recurse::shortcircuit(module, dir, callback)
- p6df::core::internal::status(_module, dir)
- p6df::core::internal::update(module, dir)
- p6df::core::module::source(relpath, relaux)
- str func_callback = p6df::core::internal::recurse::callback(callback, prefix)

### p6df-core/lib/lang.zsh

- p6df::core::lang::mgr::init(dir, name)
- p6df::core::lang::mgr::init2(cmd, name)

### p6df-core/lib/main.zsh

- p6df::core::main::init()
- p6df::core::main::self::init()
- p6df::core::timing::init()

### p6df-core/lib/module.zsh

- p6df::core::module::add(short_module, _dir)
- p6df::core::module::add::export()
- p6df::core::module::add::lazy(short_module, _dir)
- p6df::core::module::brews(module, dir)
- p6df::core::module::diag(module, dir)
- p6df::core::module::diff(module, dir)
- p6df::core::module::doc(module, dir)
- p6df::core::module::fetch(module, dir)
- p6df::core::module::init()
- p6df::core::module::langs(module, dir)
- p6df::core::module::parse(module, _dir)
- p6df::core::module::pull(module, dir)
- p6df::core::module::push(module, dir)
- p6df::core::module::status(module, dir)
- p6df::core::module::symlinks(module, dir)
- p6df::core::module::sync(module, dir)
- p6df::core::module::update(module, dir)
- p6df::core::module::use(short_module, dir)
- p6df::core::module::vscodes(module, dir)
- str module = p6df::core::module::expand(short_module, _dir)
- str str = p6df::core::module::env::name(module, _dir, callback)

### p6df-core/lib/modules.zsh

- p6df::core::modules::bootstrap::p6common([dir=$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6common])
- p6df::core::modules::brews()
- p6df::core::modules::foreach(callback)
- p6df::core::modules::init()
- p6df::core::modules::langs()
- p6df::core::modules::load()
- p6df::core::modules::symlinks()
- p6df::core::modules::vscodes()

### p6df-core/lib/path.zsh

- p6df::core::path::cd::if(dir)
- p6df::core::path::cd::init()
- p6df::core::path::if(dir)
- p6df::core::path::init(dir)

### p6df-core/lib/prompt.zsh

- p6df::core::prompt::init()
- p6df::core::prompt::lang::env::off(lang)
- p6df::core::prompt::lang::line::add(thing)
- p6df::core::prompt::lang::line::remove(thing)
- p6df::core::prompt::line::add(thing)
- p6df::core::prompt::line::remove(thing)
- p6df::core::prompt::module::init(module)
- p6df::core::prompt::runtime()
- str str = p6df::core::lang::prompt::env::line()
- str str = p6df::core::lang::prompt::line(str, f)

### p6df-core/lib/theme.zsh

- p6df::core::theme::init()

### p6df-core/lib/user.zsh

- p6df::core::user::init()

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
│   ├── prompt.zsh
│   ├── theme.zsh
│   └── user.zsh
├── README.md
└── share

6 directories, 24 files
```

## Author

Philip M . Gollucci <pgollucci@p6m7g8.com>
