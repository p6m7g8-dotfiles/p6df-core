# .zshrc
#   p6df::core::init
#     p6df::core::main::init
#      	p6df::core::user::init --> "$HOME/.zsh-me
#
#       p6df::core::modules::init
#         p6df::user::modules
#       	p6df::user::modules::init::pre $P6_AWS_ORG
#      	p6df::core::modules::foreach "p6df::core::module::init" $P6_DFZ_MODULES
#         p6df::core::module::init "$module"<---+
#           return if loaded                    |
#          	p6_run_if "$func_deps"              |
#           foreach dep                         |
#             recurse >-------------------------+
#   	    p6_run_if "$func_callback" #init (tail recursive)
#         p6df::core::prompt::module::init
#         p6df::core::aliases::module::init
#
#         p6df::user::modules::init::post
#
# bin/p6df
#   p6df::core::cli::run
#     p6df::core::module::$cmd
