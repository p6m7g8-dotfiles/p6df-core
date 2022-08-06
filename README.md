# p6df-core

## Table of Contents


### p6df-core
- [p6df-core](#p6df-core)
  - [Badges](#badges)
  - [Distributions](#distributions)
  - [Summary](#summary)
  - [Contributing](#contributing)
  - [Code of Conduct](#code-of-conduct)
  - [Changes](#changes)
    - [Usage](#usage)
  - [Author](#author)

### Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/p6m7g8/p6df-core)
[![Mergify](https://img.shields.io/endpoint.svg?url=https://gh.mergify.io/badges/p6m7g8/p6df-core/&style=flat)](https://mergify.io)
[![codecov](https://codecov.io/gh/p6m7g8/p6df-core/branch/master/graph/badge.svg?token=14Yj1fZbew)](https://codecov.io/gh/p6m7g8/p6df-core)
[![Known Vulnerabilities](https://snyk.io/test/github/p6m7g8/p6df-core/badge.svg?targetFile=package.json)](https://snyk.io/test/github/p6m7g8/p6df-core?targetFile=package.json)
[![Gihub repo dependents](https://badgen.net/github/dependents-repo/p6m7g8/p6df-core)](https://github.com/p6m7g8/p6df-core/network/dependents?dependent_type=REPOSITORY)
[![Gihub package dependents](https://badgen.net/github/dependents-pkg/p6m7g8/p6df-core)](https://github.com/p6m7g8/p6df-core/network/dependents?dependent_type=PACKAGE)

## Summary

## Contributing

- [How to Contribute](CONTRIBUTING.md)

## Code of Conduct

- [Code of Conduct](https://github.com/p6m7g8/.github/blob/master/CODE_OF_CONDUCT.md)

## Changes

- [Change Log](CHANGELOG.md)

## Usage

### p6df-core/lib:

#### p6df-core/lib/aliases.zsh:

- p6df::core::aliases::init()

#### p6df-core/lib/cli.zsh:

- p6df::core::cli::all(cmd, ...)
- p6df::core::cli::all::run(dir)
- p6df::core::cli::run(...)
- p6df::core::cli::usage([rc=0], [msg=])

#### p6df-core/lib/dev.zsh:

- p6df::core::dev::dot(module, dep)
- p6df::core::dev::graph()

#### p6df-core/lib/file.zsh:

- p6df::core::file::load(file)

#### p6df-core/lib/internal.zsh:

- p6df::core::internal::branch(_module, dir)
- p6df::core::internal::debug(msg)
- p6df::core::internal::diag(module, dir)
- p6df::core::internal::diff(_module, dir)
- p6df::core::internal::doc(_module, dir)
- p6df::core::internal::fetch()
- p6df::core::internal::langs(module, dir)
- p6df::core::internal::pull(_module, dir)
- p6df::core::internal::push(_module, dir)
- p6df::core::internal::recurse(module, dir, callback, ...)
- p6df::core::internal::status(_module, dir)
- p6df::core::internal::update(module, dir)
- p6df::core::module::source(relpath, relaux)

#### p6df-core/lib/main.zsh:

- p6df::core::main::init()
- p6df::core::main::self::init()
- p6df::core::timing::init()

#### p6df-core/lib/module.zsh:

- p6df::core::module::add(short_module, _dir)
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

#### p6df-core/lib/modules.zsh:

- p6df::core::modules::bootstrap::p6common([dir=$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6common])
- p6df::core::modules::brews()
- p6df::core::modules::foreach(callback)
- p6df::core::modules::init()
- p6df::core::modules::langs()
- p6df::core::modules::load()
- p6df::core::modules::symlinks()
- p6df::core::modules::vscodes()

#### p6df-core/lib/path.zsh:

- p6df::core::path::cd::if(dir)
- p6df::core::path::cd::init()
- p6df::core::path::if(dir)
- p6df::core::path::init(dir)

#### p6df-core/lib/prompt.zsh:

- p6_lang_envs_prompt_info()
- p6_lang_prompt_info()
- p6df::core::prompt::init()
- p6df::core::prompt::lang::env::off(lang)
- p6df::core::prompt::lang::line::add(thing)
- p6df::core::prompt::lang::line::remove(thing)
- p6df::core::prompt::line::add(thing)
- p6df::core::prompt::line::remove(thing)
- p6df::core::prompt::process()
- p6df::core::prompt::runtime()

#### p6df-core/lib/theme.zsh:

- p6df::core::theme::init()

#### p6df-core/lib/user.zsh:

- p6df::core::user::init()



## Hier
```text
.
├── _bootstrap.zsh
├── aliases.zsh
├── cli.zsh
├── dev.zsh
├── file.zsh
├── internal.zsh
├── main.zsh
├── module.zsh
├── modules.zsh
├── path.zsh
├── prompt.zsh
├── theme.zsh
└── user.zsh

0 directories, 13 files
```
## Author

Philip M . Gollucci <pgollucci@p6m7g8.com>
