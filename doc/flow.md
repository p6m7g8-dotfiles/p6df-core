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
      ├─ p6df::core::user::init
      │  └─ load "$HOME/.zsh-me..."
      └─ p6df::core::modules::init
         ├─ p6df::user::modules
         ├─ p6df::user::modules::init::pre $P6_AWS_ORG
         ├─ p6df::core::modules::foreach "p6df::core::module::init" $P6_DFZ_MODULES
         │  └─ p6df::core::module::init "$module"
         │     ├─ return if already loaded
         │     ├─ run deps hook, recurse through dependency chain
         │     └─ run init hook
         ├─ p6df::core::prompt::module::init
         ├─ p6df::core::aliases::module::init
         └─ p6df::user::modules::init::post
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
