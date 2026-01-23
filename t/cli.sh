# shellcheck shell=bash

main() {

	. ../../p6common/lib/_bootstrap.sh
	p6_bootstrap "../../p6common"

	p6_test_setup "6"

	# Source the p6df-core libraries
	. $P6_DFZ_LIB_DIR/_bootstrap.zsh
	p6df::core::_bootstrap

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
	# Test 2: p6df::core::cli::all::run receives and uses cmd parameter
	######################################################################
	p6_test_start "p6df::core::cli::all::run receives cmd parameter"
	(
		# Mock the internal recurse to capture what cmd was passed
		p6_test_run "
			p6df::core::internal::recurse() {
				local callback=\$3
				echo \$callback | sed 's/p6df::core::internal:://'
			}
			p6df::core::module::expand() { echo 'p6df-test'; }
			p6_uri_name() { echo 'test'; }
			p6_h2() { :; }
			mkdir -p testmod
			p6df::core::cli::all::run testmod status
		"
		p6_test_assert_run_ok "cmd passed correctly" 0 "status"
	)
	p6_test_finish

	######################################################################
	# Test 3: Variable scoping - no unbound variable errors with set -u
	######################################################################
	p6_test_start "cmd variable properly scoped"
	(
		p6_test_run "
			set -u
			p6df::core::internal::recurse() { return 0; }
			p6df::core::module::expand() { echo 'p6df-test'; }
			p6_uri_name() { echo 'test'; }
			p6_h2() { :; }
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
		p6_test_run "grep -A 5 'p6df::core::cli::all::run()' $P6_DFZ_LIB_DIR/cli.zsh | grep -q 'local cmd=\"\$2\"'"
		p6_test_assert_run_rc "cmd=\$2 found" 0
	)
	p6_test_finish

	######################################################################
	# Test 5: cmd parameter passed from all to all::run
	######################################################################
	p6_test_start "cmd passed from all to all::run"
	(
		p6_test_run "grep 'p6df::core::cli::all::run' $P6_DFZ_LIB_DIR/cli.zsh | grep -q '\"\$dir\" \"\$cmd\"'"
		p6_test_assert_run_rc "cmd passed in call" 0
	)
	p6_test_finish

	p6_test_teardown
}

main "$@"
