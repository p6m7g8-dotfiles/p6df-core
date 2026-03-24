# shellcheck shell=bash

main() {

	# Support CI (P6_DFZ_SRC_P6M7G8_DOTFILES_DIR=.) and local dev environments
	local p6df_root
	p6df_root="$(cd "${P6_DFZ_SRC_P6M7G8_DOTFILES_DIR:-.}" && pwd)"

	local p6common_dir="$p6df_root/p6common"
	. "$p6common_dir/lib/_bootstrap.sh"
	p6_bootstrap "$p6common_dir"

	# Set absolute path so test subshells that cd to temp dirs can still access lib files
	if [ -z "${P6_DFZ_LIB_DIR:-}" ]; then
		P6_DFZ_LIB_DIR="$p6df_root/lib"
	fi

	p6_test_setup "6"

	# Load the cli.zsh module under test directly (avoids network/module dependencies)
	. "$P6_DFZ_LIB_DIR/cli.zsh"

	######################################################################
	# Test 1: cli.zsh has valid syntax
	######################################################################
	p6_test_start "cli.zsh has valid zsh syntax"
	(
		p6_test_run "zsh -n $P6_DFZ_LIB_DIR/cli.zsh"
		p6_test_assert_run_rc "syntax valid" 0
	)
	p6_test_finish

	######################################################################
	# Test 2: p6df::core::cli::all::run dispatches cmd via case statement
	######################################################################
	p6_test_start "p6df::core::cli::all::run dispatches via case"
	(
		p6_test_run "
			p6_uri_name() { echo 'test'; }
			p6_h2() { :; }
			p6df::core::module::status() { return 0; }
			mkdir -p testmod
			p6df::core::cli::all::run testmod status
		"
		p6_test_assert_run_rc "case dispatch rc" 0
	)
	p6_test_finish

	######################################################################
	# Test 3: Variable scoping - no unbound variable errors with set -u
	######################################################################
	p6_test_start "cmd variable properly scoped"
	(
		p6_test_run "
			set -u
			p6_uri_name() { echo 'test'; }
			p6_h2() { :; }
			p6df::core::module::status() { return 0; }
			mkdir -p testdir
			p6df::core::cli::all::run testdir status 2>&1
		"
		p6_test_assert_run_rc "no unbound variable" 0
	)
	p6_test_finish

	######################################################################
	# Test 4: cmd parameter properly defined in code
	######################################################################
	p6_test_start "cmd parameter defined in all::run"
	(
		p6_test_run "p6_filter_row_select_and_after 'p6df::core::cli::all::run()' 5 < $P6_DFZ_LIB_DIR/cli.zsh | p6_filter_row_select 'local cmd=\"\$2\"' >/dev/null"
		p6_test_assert_run_rc "cmd=\$2 found" 0
	)
	p6_test_finish

	######################################################################
	# Test 5: cmd parameter passed from all to all::run
	######################################################################
	p6_test_start "cmd passed from all to all::run"
	(
		p6_test_run "p6_filter_row_select 'p6df::core::cli::all::run' < $P6_DFZ_LIB_DIR/cli.zsh | p6_filter_row_select '\"\$dir\" \"\$cmd\"' >/dev/null"
		p6_test_assert_run_rc "cmd passed in call" 0
	)
	p6_test_finish

	######################################################################
	# Test 6: extra args are forwarded past dir and cmd to module function
	######################################################################
	p6_test_start "extra args forwarded past dir and cmd"
	(
		p6_test_run "
			p6_uri_name() { echo 'test'; }
			p6_h2() { :; }
			p6df::core::module::deploy() { return 0; }
			mkdir -p testdir2
			p6df::core::cli::all::run testdir2 deploy extra1 extra2
		"
		p6_test_assert_run_rc "extra args forwarded rc" 0
	)
	p6_test_finish

	p6_test_teardown
}

main "$@"
