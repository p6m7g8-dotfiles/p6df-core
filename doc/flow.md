# p6df Initialization and CLI Flow

This doc is the quick reference for boot flow and CLI dispatch in `p6df-core`.

## Entry Points

- Shell init: `.zshrc`
- CLI entry: `bin/p6df`

## Shell Initialization Flow

```text
.zshrc
└─ p6df::core::init
   └─ p6df::core::main::init
      ├─ p6df::core::timing::init
      ├─ p6df::core::main::self::init
      ├─ p6df::core::user::init
      │  └─ load "$HOME/.zsh-me..."
      ├─ p6df::core::path::init          # seed $PATH
      ├─ p6df::core::path::cd::init      # seed $cdpath
      ├─ p6df::core::aliases::init       # core aliases
      ├─ p6df::core::prompt::init
      └─ p6df::core::modules::init
         ├─ p6df::user::modules
         ├─ p6df::user::modules::init::pre
         ├─ p6df::core::homebrew::init
         ├─ p6df::core::modules::load
         │  └─ p6df::core::modules::foreach "p6df::core::module::init" $P6_DFZ_MODULES
         │     └─ p6df::core::module::init(module, dir)
         │        ├─ p6df::core::bootstrap::module::init   → p6_bootstrap lib/
         │        ├─ p6df::core::internal::recurse
         │        │  ├─ shortcircuit (once per module per callback)
         │        │  ├─ p6_file_load init.zsh
         │        │  ├─ deps::each → internal::recurse (recursive)
         │        │  └─ ::init hook
         │        ├─ p6df::core::env::module::init         → env::init
         │        ├─ p6df::core::path::module::init        → path::init
         │        ├─ p6df::core::cdpath::module::init      → cdpath::init
         │        ├─ p6df::core::fpath::module::init       → fpath::init
         │        ├─ p6df::core::completions::module::init → completions::init
         │        ├─ p6df::core::aliases::module::init     → aliases::init
         │        ├─ p6df::core::langmgr::module::init     → langmgr::init
         │        └─ p6df::core::prompt::module::init      → prompt::init, prompt::lang, prompt::env, profile::mod, prompt::mod::bottom
         └─ p6df::user::modules::init::post
      └─ p6df::core::theme::init
```

## CLI Dispatch Flow

```text
bin/p6df
└─ p6df::core::cli::run
   └─ p6df::core::module::$cmd
```

Supported command dispatch targets:

- `init`, `brews`, `langs`, `mcp`, `symlinks`, `vscodes`, `doc`
- `fetch`, `update`, `pull`, `push`, `diff`, `status`, `diag`, `sync`

## MCP Hook Flow

`mcp` is CLI-only (it is not part of shell init).

```text
bin/p6df mcp [module]
└─ p6df::core::module::mcp(module, dir)
   └─ p6df::core::internal::recurse(module, dir, "mcp")
      └─ p6df::modules::<mod>::mcp(module, dir)
         ├─ install MCP server packages
         └─ add server bin dirs to PATH
```

MCP auth/env config is handled in downstream modules via `profile::on` and `profile::off` hooks
(for example `p6df-1password`, `p6df-claude`), not in `p6df-core`.

## Profile Hook Flow

```text
<selector script>
├─ p6df::core::profile::module::on(module, profile, code)
│  ├─ dispatches to <mod>::profile::on if defined
│  └─ default: p6_run_code "$code"            # export credential env vars
│
└─ p6df::core::profile::module::off(module, code)
   ├─ dispatches to <mod>::profile::off if defined
   └─ default: p6_env_unset_from_code "$code" # unset credential env vars
```
