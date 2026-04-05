# p6m7g8-dotfiles Architecture

> Claude-optimized reference. Precise, dense, no fluff.

## Repository Layout

```
~/.p6/p6m7g8-dotfiles/
├── p6df-core/          # Framework kernel — bootstrap, module lifecycle, CLI, prompt
├── p6df-<name>/        # 102 feature modules (tools, languages, cloud platforms)
└── .github/            # GHA workflows, PR/issue templates
├── p6<name>/           # 13 helper library modules (p6common, p6aws, p6git, …)
└── .github/            # GHA workflows, PR/issue templates
```

**Key invariant:** `p6df-core` is the only module loaded unconditionally. Every other module is opt-in via `p6df::user::modules`.

---

## Module Anatomy

### Directory Structure

```
p6df-<name>/
├── init.zsh       # REQUIRED — defines all hook functions
├── conf/          # Optional - config
├── lib/           # Optional — helper scripts (bash/POSIX)
│   └── *.sh
├── libexec/       # Optional — standalone executables
├── share/         # Optional — config files, assets
└── README.md
```

### Function Naming Pattern

All hooks follow: `p6df::modules::<name>::<hook>`

Where `<name>` is derived from the repo name with hyphens converted to `::` separators as needed. The framework computes function names via `p6df::core::module::parse`.

---

## Namespace Conventions

| Prefix | Scope |
|--------|-------|
| `p6df::core::` | Framework internals |
| `p6df::modules::<name>::` | Module-specific hooks |
| `p6df::user::` | User customization (defined in `~/.zsh-me`) |
| `p6_` | Utility functions from p6common |

---

## Prompt System

- Multi-line dynamic prompt built at render time
- Modules register render functions via `p6df::core::prompt::line::add::*`
- Line categories: `lang`, `runtime`, `context`, `system`, `env`, `mod`, `mod_bottom`
- Each category aggregates function names into `P6_DFZ_PROMPT_<CATEGORY>_LINES`
- On each prompt: framework iterates the list, calls each function, concatenates output
- Secrets/tokens are redacted before display

---
