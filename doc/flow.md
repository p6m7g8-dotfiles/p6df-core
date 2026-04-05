# Shell Load Flow

```text
~/.zshenv  (symlink → conf/zshenv-xdg)
  ├─ P6_DFZ_SRC_DIR=$HOME/.p6
  ├─ P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
  ├─ P6_DEBUG='', P6_VERBOSE=0
  └─ . conf/zshenv
       ├─ unsetopt GLOBAL_RCS            # suppress /etc/{zprofile,zshrc,zlogin}
       ├─ P6_DFZ_LIB_DIR=.../p6df-core/lib
       ├─ ZDOTDIR=$HOME

~/.zshrc  (symlink → conf/zshrc)
  └─ p6df::core::init
       ├─ . lib/main.zsh
       └─ p6df::core::main::init
            ├─ p6df::core::timing::init
            ├─ p6df::core::main::self::init
            │    └─ p6df::core::modules::bootstrap::p6common
            ├─ p6df::core::user::init
            │    └─ . ~/.zsh-me  (symlink → pgollucci/home/.zsh-me)
            │         # defines (called later):
            │         #   p6df::user::modules
            │         #   p6df::user::modules::init::pre
            │         #   p6df::user::modules::init::post
            │         #   p6df::user::prompt
            │         #   p6df::user::theme
            ├─ p6df::core::path::init
            ├─ p6df::core::path::cd::init
            ├─ p6df::core::aliases::init
            ├─ p6df::core::homebrew::init
            ├─ p6df::core::modules::init
            │    ├─ p6df::user::modules
            │    ├─ p6df::user::modules::init::pre
            │    ├─ p6df::core::homebrew::init
            │    ├─ p6df::core::modules::load
            │    │    └─ for each module in P6_DFZ_MODULES:
            │    │         p6df::core::module::init
            │    │           ├─ p6df::core::bootstrap::module::init  # init
            │    │           ├─ p6df::core::internal::recurse        # Tail Recurse
            │    │           ├─ p6df::core::env::module::init        # Lifecycle hooks
            │    │           ├─ p6df::core::path::module::init
            │    │           ├─ p6df::core::cdpath::module::init
            │    │           ├─ p6df::core::fpath::module::init
            │    │           ├─ p6df::core::completions::module::init
            │    │           ├─ p6df::core::aliases::module::init
            │    │           ├─ p6df::core::langmgr::module::init
            │    │           └─ p6df::core::prompt::module::init
            │    └─ p6df::user::modules::init::post
            │         └─ . $HOME/home/init.zsh
            └─ p6df::core::theme::init
                 └─ p6df::user::theme
```
