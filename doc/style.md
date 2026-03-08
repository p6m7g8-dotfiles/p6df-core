# p6m7g8-dotfiles Style

Shared coding style for all `p6m7g8-dotfiles` repos.

## Always

- Prefer `p6_*` and `p6df::*` helpers before raw shell commands.
- Follow variable and return doc-comment conventions so `p6df doc` can parse output.
- Run `p6df doc` after changes in a module directory.
- Keep one blank line after argument/local declarations.
- End functions with one `p6_return_*`.
- Use `shift 0` when handling variadic args.
- Use Bash/Zsh style in `*.zsh`.
- Use POSIX style in `*.sh`.

## Never

- Pollute the top-level namespace.
- Naming precedence is: `p6|p6df` -> `p6_` -> alias -> function.
