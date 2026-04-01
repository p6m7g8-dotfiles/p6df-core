# AGENTS.md

## Scope

This repository (`p6df-core`) owns framework recursion, dispatch, and wiring.
Important sibling repos:

- `../pgollucci/home`
- `../p6m7g8-actions`
- `../p6m7g8`

## Read Order

1. `doc/hook_api.md`
2. `doc/flow.md`
3. `../p6df-github/docs/PR.md`
4. `lib/module.zsh`
5. `lib/modules.zsh`

## Ownership Boundaries

- `p6df-core`: recursion/dispatch framework and shared wiring
- `p6df-*`: Zsh integration and environment wiring
- `p6*` and `p6common`: reusable POSIX/Bash/domain logic
- `../<user>/home`: personal profile/home modules
- `../bid-ops-development/p6df-arkestro`: work profile/home modules

## Triage Map

1. Zsh integration issue: check module `init.zsh`, then `lib/`
2. Recursion/dispatch issue: check `lib/*.zsh` in `p6df-core`
3. Reusable logic issue: check `p6common` or sibling `p6*` repo
4. Profile/account issue: check selector and `profile::on`/`profile::off`

## Preferred CLIs

- `bin/p6df` for lifecycle/recursion:
  `status`, `diff`, `pull`, `push`, `langs`, `brews`, `mcp`, `vscodes`, `symlinks`, `diag`, `fetch`, `update`
- `../p6df/bin/p6install` for bootstrap only
- `../p6common/bin/p6ctl` for shared control behavior

## Editing Contract

- Make narrow, additive edits in the owning layer.
- Preserve boundaries: `p6df-*` wiring vs `p6*` reusable logic.
- Regenerate docs/README when changing APIs.
- If a sibling repo owns the concern, fix and validate there.

## Language Managers

- Use `p6df-$lang` conventions (`goenv`, `jenv`, `nodenv`, `luaenv`, `plenv`, `rbenv`, `rustenv`, `scalaenv`, `ux`).
- NEVER use uvx, npx or variants in any language

## Shell and Profile Requirements

- Agent command shell must be `zsh -li`
- Never use bash for agent commands in this repo
- Never run zsh without both `-l` and `-i`
- Before running commands, load exactly one profile: home or arkestro (never both, never neither)
