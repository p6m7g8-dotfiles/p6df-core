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

## external::brew

- Presence: OPTIONAL
- Purpose: install external packages.

Choose intentionally between `clones()`, `deps()`, and `external::brew`.
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
hooks (implemented in downstream modules such as `p6df-1password`, `p6df-claudecode`, etc.), not
in `p6df-core`. Secrets are typically fetched inside a profile selector and exported before MCP
servers are started.

## aliases::init

- Presence: OPTIONAL
- Purpose: define module aliases.

Aliases should be namespaced and should call functions (not shell one-liners).

## path::init

- Presence: OPTIONAL
- Purpose: add module path entries.

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

## prompt::mod

- Presence: OPTIONAL
- Purpose: render the module's prompt segment.

Use this hook for visible prompt content.
