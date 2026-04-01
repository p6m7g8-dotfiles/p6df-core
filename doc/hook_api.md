# Hook API

Module hooks are implemented as `p6df::modules::<mod>::<hook>`.
Unless noted, hooks are optional.

## init(module, dir)

- Presence: OPTIONAL
- Purpose: module setup after `init.zsh` is loaded.

Framework callers (`p6df::core::main::init`, `p6df::core::module::use`, and tool paths that load modules)
invoke this automatically.

## deps()

- Presence: REQUIRED

Declare runtime module dependencies.
Guidelines:

- Depend on what the module actually uses.
- Most modules depend on `p6common` directly or transitively.
- Dependency recursion is handled by the framework.
- Use `clones()` for repos that are not required at module runtime.

## home::symlinks

- Presence: OPTIONAL
- Purpose: symlink versioned config files into place.

Some files may require token substitution for secrets.

## external::brews

- Presence: OPTIONAL
- Purpose: install external packages.

Choose intentionally between `clones()`, `deps()`, and `external::brews`.
Install prerequisites needed by `langs()`. Only language-specific setup should wait for `langs()`.

## langs(module, dir)

- Presence: OPTIONAL
- Purpose: install language managers and ecosystem tooling.

Includes third-party language tooling (`cran`, `uv`, `cpan`, `gems`, etc.).
Do not use brew for language ecosystem tooling unless required.

## mcp(module, dir)

- Presence: OPTIONAL
- Purpose: install MCP servers for this module and expose their binaries.

Installs MCP (Model Context Protocol) servers required by this module and adds their executables to PATH.

Called via `p6df mcp` (CLI) or `p6df::core::modules::mcp` (programmatic).

Example things to do here:

- `npm install -g @modelcontextprotocol/server-github`
- `p6df::core::path::if "$HOME/.local/bin"`

MCP auth tokens and config env vars are managed by each module's `profile::on` / `profile::off`
hooks (implemented in downstream modules such as `p6df-1password`, `p6df-claude`, etc.), not
in `p6df-core`. Secrets are typically fetched inside a profile selector and exported before MCP
servers are started.

## aliases::init

- Presence: OPTIONAL
- Purpose: define module aliases.

Aliases should be namespaced and should call functions (not shell one-liners).

## path::init

- Presence: OPTIONAL
- Purpose: add module path entries.

## cdpath::init

- Presence: OPTIONAL
- Purpose: add module entries to `cdpath` (the directory search path used by `cd`).

Use `p6df::core::path::cd::if <dir>` to conditionally append a directory.

## fpath::init

- Presence: OPTIONAL
- Purpose: add module entries to `fpath` (the zsh function autoload search path).

Use this hook to expose autoloadable functions before `compinit` runs.

## env::init

- Presence: OPTIONAL
- Purpose: export module-specific environment variables.

Called during module initialisation to set variables that the module or its
tools rely on (API keys with safe defaults, feature flags, paths, etc.).
Prefer `p6_env_export KEY "${KEY:-default}"` so an already-exported value is
not overwritten.

## completions::init

- Presence: OPTIONAL
- Purpose: register shell completions for module CLIs.

## vscodes

- Presence: OPTIONAL
- Purpose: install VS Code extensions.

If a brew package or third-party language extension is only needed for VS Code, it may be installed here.

## vscodes::config

- Presence: OPTIONAL
- Purpose: emit module VS Code settings fragment.

Return valid JSON for this module and its extensions.

## prompt::init

- Presence: OPTIONAL
- Purpose: run prompt setup work.

This hook is setup-only; it does not render prompt output.

## profile::on

- Presence: OPTIONAL
- Purpose: activate a named profile for the module.

Signature: `profile::on(profile, code)`

- `profile` — an arbitrary name for the active context (e.g. `work`, `personal`).
- `code` — a shell code block (typically a series of `export KEY=value` statements)
  that is evaluated via `p6_run_code` to inject secrets or credentials.

Implementations typically:
1. Evaluate `$code` to export credential env vars.

MCP auth tokens and credential env vars are managed here (or in downstream
modules such as `p6df-1password`), not in `p6df-core`.

The default implementation (used when no module-specific hook exists) calls
`p6df::core::profile::default::on "$code"` which simply runs `p6_run_code "$code"`.

## profile::off

- Presence: OPTIONAL
- Purpose: deactivate the module's active profile.

Signature: `profile::off(code)`

- `code` — the same shell code block previously passed to `profile::on`.

Implementations typically:
1. Call `p6_env_unset_from_code "$code"` to unset all vars exported by that block.

The default implementation (used when no module-specific hook exists) calls
`p6df::core::profile::default::off "$code"` which simply runs `p6_env_unset_from_code "$code"`.

## profile::mod

- Presence: OPTIONAL
- Purpose: render the module's prompt segment.

This is the canonical mod-line prompt hook. It replaces `prompt::mod`.

Signature: `profile::mod()` — no arguments.

Return a single string. Two formats are supported:

1. **Pre-formatted string** — returned as-is in the prompt.
2. **Label + `$VAR` tokens** — `label $VAR1 $VAR2 ...`; the runtime expands each
   variable reference and formats the result as `label:\t\t  val1 val2`.

Use format 2 when the displayed values come from environment variables set by
`profile::on`, so the prompt always reflects the live value.

## prompt::mod::bottom

- Presence: OPTIONAL
- Purpose: render a module's prompt segment on the bottom prompt line.

Same return format as `profile::mod`. Use for lower-priority or wide content
that should appear below the main prompt line.
