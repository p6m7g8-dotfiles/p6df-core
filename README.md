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

#### p6df-core/lib/file.zsh:

- p6df::core::file::load(file)

#### p6df-core/lib/main.zsh:

- p6df::core::main::init()
- p6df::core::main::self::init()

#### p6df-core/lib/mgmt.zsh:

- p6df::core::mgmt::module::do(dir, callback)
- p6df::core::mgmt::modules::foreach()
- p6df::core::mgmt::modules::git::diff()
- p6df::core::mgmt::modules::git::pull()
- p6df::core::mgmt::modules::git::push()
- p6df::core::mgmt::modules::git::status()
- p6df::core::mgmt::modules::git::sync()

#### p6df-core/lib/module.zsh:

- p6df::core::module::add(short_module)
- p6df::core::module::load(module)
- p6df::core::module::parse(module)
- p6df::core::module::source(relpath, relaux)
- p6df::core::module::use(short_module)
- str P6_env_${str} = p6df::core::module::env::name(module)
- str module = p6df::core::module::expand(short_module)

#### p6df-core/lib/modules.zsh:

- p6df::core::modules::bootstrap::p6common()
- p6df::core::modules::foreach(callback)
- p6df::core::modules::init()
- p6df::core::modules::load()

#### p6df-core/lib/path.zsh:

- p6df::core::path::cd::if(dir)
- p6df::core::path::cd::init()
- p6df::core::path::if(dir)
- p6df::core::path::init()

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

#### p6df-core/lib/timing.zsh:

- p6df::core::timing::init()

#### p6df-core/lib/user.zsh:

- p6df::core::user::init()



## Hier
```text
.
├── aliases.zsh
├── file.zsh
├── main.zsh
├── mgmt.zsh
├── module.zsh
├── modules.zsh
├── path.zsh
├── prompt.zsh
├── theme.zsh
├── timing.zsh
└── user.zsh

0 directories, 11 files
```
## Author

Philip M . Gollucci <pgollucci@p6m7g8.com>
