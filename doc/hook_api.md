# Hook API

- [Hook API](#hook-api)
  - [init(module, dir)](#initmodule-dir)
  - [deps()](#deps)
  - [home::symlinks](#homesymlinks)
  - [external::brew](#externalbrew)
  - [langs(module, dir)](#langsmodule-dir)
  - [aliases::init](#aliasesinit)
  - [completions::init](#completionsinit)
  - [vscodes](#vscodes)
  - [vscodes::config](#vscodesconfig)
  - [prompt::init](#promptinit)
  - [prompt::mod](#promptmod)

## init(module, dir)

- Presence: OPTIONAL

After loading init.zsh, call p6df::modules::\$mod::init(module, dir)

`p6df::core::main::init` and `p6df::core::module::use` do this automatically as do any `p6df` tools that need a module.

## deps()

- Presence: REQUIRED

All modules should depend on `p6common` either directly because its the only `p6df` dependency
or in-directly via another module. Use what you use. `deps` are not possible to skip cloning
b/c they are used directly by the module.

`clones()` can be configured on/off or delayed.

All modules _must_ tail recurse through their dependency chain. The framework does this.

Deps is the only required hook. It doesn't make sense to only depend on `p6common` or another dep
b/c it wouldn't be used by `this` module. Instead if all you have are depends, then use `clones()`.

## home::symlinks

- Presence: OPTIONAL

Symlinks versioned config files into place. Some will need TOKEN substitutions for secrets.

## external::brew

- Presence: OPTIONAL

Installs things from package managers. A decision is to be made to use `clones()`, `deps()`, `external::brews`.
Brews will need to install things `langs()` depend on. It is expected stuff will not work with brews.
Only `langs()` specific things should not work until `langs()` is run.

## langs(module, dir)

- Presence: OPTIONAL

Installs language managers. Also installs 3rd Party Language extensions like cran, uv, cpan, gems etc.
Do not use brew for the extensions unless you must.

## aliases::init

- Presence: OPTIONAL

Sets up aliases. Every alias should be name spaced and point to a function not straight up shell one liners.

## completions::init

- Presence: OPTIONAL

Sets up shell cli completions.

## vscodes

- Presence: OPTIONAL

Installs vscode market place extensions.
If a brew or 3rd party Language extension is super related to the vscode extension and not used outside
of vscode setup then it can and should be installed here too.

## vscodes::config

- Presence: OPTIONAL

Returns a valid JSON snippet of vscode config for this module and its code extensions

## prompt::init

- Presence: OPTIONAL

If you need to do setup work do it here.
This is not what will be called to render the prompt

## prompt::mod

- Presence: OPTIONAL

This renders the actual prompt

Do you really want a module without a prompt presence of some kind?
This is not what will be called to render the prompt
