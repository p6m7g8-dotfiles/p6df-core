# AGENTS.md

## Scope

This repo is `p6df-core` in a multi-repo shell framework.
Important siblings: `../pgollucci/home`, `../p6m7g8-actions`, `../p6m7g8`.

## Read First

- `doc/hook_api.md`
- `doc/flow.md`
- `lib/module.zsh`
- `lib/modules.zsh`
- `../p6common/lib/cicd/test.sh`
- `../p6common/lib/cicd/doc.sh`

## Layers

- `p6df-core`: framework recursion/dispatch and wiring
- `p6df-*`: Zsh integration/environment wiring
- `p6*` and `p6common`: reusable POSIX/Bash/domain logic
- `../<user>/home`: user profile/home modules

## Triage

1. Zsh integration issue -> module `init.zsh`, then `lib/`
2. recursion/dispatch issue -> `lib/*.zsh` in `p6df-core`
3. reusable logic issue -> `p6common` or sibling `p6*` repo
4. profile/account issue -> selector + `profile::on/off`

## CLIs

Prefer existing CLIs:

- `bin/p6df` for lifecycle/recursion (`status`, `diff`, `pull`, `push`, `langs`, `brews`, `vscodes`,
  `symlinks`, `diag`, `fetch`, `update`)
- `../p6df/bin/p6install` for bootstrap only
- `../p6common/bin/p6ctl` for shared control behavior

## Editing Rules

- Make narrow, additive edits in the owning layer.
- Preserve boundaries: `p6df-*` wiring vs `p6*` reusable logic.
- Regenerate docs/README when changing any API.
- If sibling repos own the concern, fix and validate there.
