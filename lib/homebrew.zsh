# shellcheck shell=bash

######################################################################
#<
#
# Function: p6df::core::homebrew::init()
#
#  Environment:	 EDITOR HOME HOMEBREW_CASK_OPTS HOMEBREW_CELLAR HOMEBREW_EDITOR HOMEBREW_NO_ANALYTICS HOMEBREW_NO_AUTO_UPDATE HOMEBREW_NO_ENV_HINTS HOMEBREW_NO_INSTALL_CLEANUP HOMEBREW_NO_INSTALL_UPGRADE HOMEBREW_NO_UPDATE_REPORT_NEW HOMEBREW_PREFIX HOMEBREW_REPOSITORY HOMEBREW_SVN INFOPATH VISUAL
#>
#/ Synopsis
#/   Warning: Using vim because no editor was set in the environment.
#/   This may change in the future, so we recommend setting EDITOR,
#/   or HOMEBREW_EDITOR to your preferred text editor.
######################################################################
p6df::core::homebrew::init() {

  local homebrew_prefix="/opt/homebrew" # Homebrew prefix location for Apple Silicon.

  # Required (changed)
  p6_env_export "HOMEBREW_PREFIX" "$homebrew_prefix" # Forces Homebrew to use /opt/homebrew as its prefix.
  p6_env_export "HOMEBREW_CELLAR" "$homebrew_prefix/Cellar" # Stores formulae in /opt/homebrew/Cellar.
  p6_env_export "HOMEBREW_REPOSITORY" "$homebrew_prefix" # Treats /opt/homebrew as the brew repository path.
  p6_env_export "INFOPATH" "$homebrew_prefix/share/info:${INFOPATH:-}" # Adds Homebrew info pages to Info search path.

  # Recommended (changed)
  p6_env_export "HOMEBREW_NO_ANALYTICS" "1" # Disables Homebrew analytics collection.
  p6_env_export "HOMEBREW_NO_AUTO_UPDATE" "${HOMEBREW_NO_AUTO_UPDATE:-1}" # Skips auto-update checks unless explicitly enabled.
  p6_env_export "HOMEBREW_NO_ENV_HINTS" "${HOMEBREW_NO_ENV_HINTS:-1}" # Suppresses environment hint warnings.
  p6_env_export "HOMEBREW_NO_INSTALL_CLEANUP" "${HOMEBREW_NO_INSTALL_CLEANUP:-1}" # Prevents post-install cleanup.
  p6_env_export "HOMEBREW_NO_INSTALL_UPGRADE" "${HOMEBREW_NO_INSTALL_UPGRADE:-1}" # Prevents implicit upgrades during install.
  p6_env_export "HOMEBREW_NO_UPDATE_REPORT_NEW" "${HOMEBREW_NO_UPDATE_REPORT_NEW:-1}" # Suppresses update report messages.
  p6_env_export "HOMEBREW_EDITOR" "${HOMEBREW_EDITOR:-${EDITOR:-${VISUAL:-vim}}}" # Uses $HOMEBREW_EDITOR/$EDITOR/$VISUAL or falls back to vim.
  p6_env_export "HOMEBREW_CASK_OPTS" "${HOMEBREW_CASK_OPTS:---appdir=/Applications --fontdir=$HOME/Library/Fonts}" # Installs cask apps to /Applications and fonts to ~/Library/Fonts.
  p6_env_export "HOMEBREW_SVN" "${HOMEBREW_SVN:-svn}" # Uses system svn unless overridden.

  # Optional (not changed)
  # local homebrew_cache_default="$HOME/Library/Caches/Homebrew" # Default cache path on macOS.
  # local homebrew_logs_default="$HOME/Library/Logs/Homebrew" # Default logs path on macOS.
  # local homebrew_temp_default="/private/tmp" # Default temp path on macOS.
  # local homebrew_livecheck_watchlist_default # Default livecheck watchlist path.
  # local homebrew_make_jobs_default="" # Default make jobs (CPU count when detected).
  # local homebrew_auto_update_secs_default="86400" # Default auto-update interval (24h unless overridden).
  # local homebrew_forbid_paths_default="" # Default forbid-paths setting (enabled when not developer).
  # local homebrew_install_badge_default=$'\\U0001F37A' # Default install badge (Beer Mug emoji).
  #
  # if [[ -n "${XDG_CONFIG_HOME:-}" ]]; then
  #   homebrew_livecheck_watchlist_default="$XDG_CONFIG_HOME/homebrew/livecheck_watchlist.txt"
  # else
  #   homebrew_livecheck_watchlist_default="$HOME/.homebrew/livecheck_watchlist.txt"
  # fi
  #
  # if command -v sysctl >/dev/null 2>&1; then
  #   homebrew_make_jobs_default="$(sysctl -n hw.ncpu 2>/dev/null)"
  # fi
  #
  # if [[ -n "${HOMEBREW_NO_INSTALL_FROM_API:-}" ]]; then
  #   homebrew_auto_update_secs_default="300"
  # elif [[ -n "${HOMEBREW_DEVELOPER:-}" ]]; then
  #   homebrew_auto_update_secs_default="3600"
  # fi
  #
  # if [[ -z "${HOMEBREW_DEVELOPER:-}" ]]; then
  #   homebrew_forbid_paths_default="1"
  # fi
  #
  # p6_env_export "HOMEBREW_API_AUTO_UPDATE_SECS" "${HOMEBREW_API_AUTO_UPDATE_SECS:-450}" # API auto-update interval default (450s).
  # p6_env_export "HOMEBREW_API_DOMAIN" "${HOMEBREW_API_DOMAIN:-https://formulae.brew.sh/api}" # JSON API domain default.
  # p6_env_export "HOMEBREW_ARCH" "${HOMEBREW_ARCH:-native}" # Compiler -march default for Linux (native).
  # p6_env_export "HOMEBREW_AUTO_UPDATE_SECS" "${HOMEBREW_AUTO_UPDATE_SECS:-$homebrew_auto_update_secs_default}" # brew update interval default.
  # p6_env_export "HOMEBREW_BAT_CONFIG_PATH" "${HOMEBREW_BAT_CONFIG_PATH:-${BAT_CONFIG_PATH:-}}" # bat config path default.
  # p6_env_export "HOMEBREW_BAT_THEME" "${HOMEBREW_BAT_THEME:-${BAT_THEME:-}}" # bat theme default.
  # p6_env_export "HOMEBREW_BOTTLE_DOMAIN" "${HOMEBREW_BOTTLE_DOMAIN:-https://ghcr.io/v2/homebrew/core}" # Bottle domain default.
  # p6_env_export "HOMEBREW_BREW_GIT_REMOTE" "${HOMEBREW_BREW_GIT_REMOTE:-https://github.com/Homebrew/brew}" # Brew git remote default.
  # p6_env_export "HOMEBREW_BROWSER" "${HOMEBREW_BROWSER:-${BROWSER:-}}" # Browser preference default.
  # p6_env_export "HOMEBREW_CACHE" "${HOMEBREW_CACHE:-$homebrew_cache_default}" # Cache path default.
  # p6_env_export "HOMEBREW_CLEANUP_MAX_AGE_DAYS" "${HOMEBREW_CLEANUP_MAX_AGE_DAYS:-120}" # Cleanup age threshold default.
  # p6_env_export "HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS" "${HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS:-30}" # Full cleanup period default.
  # p6_env_export "HOMEBREW_CORE_GIT_REMOTE" "${HOMEBREW_CORE_GIT_REMOTE:-https://github.com/Homebrew/homebrew-core}" # Core git remote default.
  # p6_env_export "HOMEBREW_CURL_PATH" "${HOMEBREW_CURL_PATH:-curl}" # curl binary default.
  # p6_env_export "HOMEBREW_CURL_RETRIES" "${HOMEBREW_CURL_RETRIES:-3}" # curl retries default.
  # p6_env_export "HOMEBREW_DISPLAY" "${HOMEBREW_DISPLAY:-${DISPLAY:-}}" # DISPLAY default.
  # p6_env_export "HOMEBREW_DOWNLOAD_CONCURRENCY" "${HOMEBREW_DOWNLOAD_CONCURRENCY:-auto}" # Download concurrency default.
  # p6_env_export "HOMEBREW_FAIL_LOG_LINES" "${HOMEBREW_FAIL_LOG_LINES:-15}" # Log lines on failure default.
  # p6_env_export "HOMEBREW_FORBIDDEN_OWNER" "${HOMEBREW_FORBIDDEN_OWNER:-you}" # Forbidden owner default.
  # p6_env_export "HOMEBREW_FORBID_PACKAGES_FROM_PATHS" "${HOMEBREW_FORBID_PACKAGES_FROM_PATHS:-$homebrew_forbid_paths_default}" # Forbid installs from paths unless developer.
  # p6_env_export "HOMEBREW_GIT_PATH" "${HOMEBREW_GIT_PATH:-git}" # git binary default.
  # p6_env_export "HOMEBREW_INSTALL_BADGE" "${HOMEBREW_INSTALL_BADGE:-$homebrew_install_badge_default}" # Default install badge emoji.
  # p6_env_export "HOMEBREW_LIVECHECK_WATCHLIST" "${HOMEBREW_LIVECHECK_WATCHLIST:-$homebrew_livecheck_watchlist_default}" # Livecheck watchlist default.
  # p6_env_export "HOMEBREW_LOGS" "${HOMEBREW_LOGS:-$homebrew_logs_default}" # Logs path default.
  # p6_env_export "HOMEBREW_MAKE_JOBS" "${HOMEBREW_MAKE_JOBS:-$homebrew_make_jobs_default}" # Make jobs default (CPU count).
  # p6_env_export "HOMEBREW_NO_COLOR" "${HOMEBREW_NO_COLOR:-${NO_COLOR:-}}" # Respect NO_COLOR if set.
  # p6_env_export "HOMEBREW_PIP_INDEX_URL" "${HOMEBREW_PIP_INDEX_URL:-https://pypi.org/simple}" # PIP index default.
  # p6_env_export "HOMEBREW_SSH_CONFIG_PATH" "${HOMEBREW_SSH_CONFIG_PATH:-$HOME/.ssh/config}" # SSH config path default.
  # p6_env_export "HOMEBREW_TEMP" "${HOMEBREW_TEMP:-$homebrew_temp_default}" # Temp directory default.

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::cmd::brew(...)
#
#  Args:
#	... - 
#
#>
######################################################################
p6df::core::homebrew::cmd::brew() {
  shift 0

  NONINTERACTIVE=1 brew "$@"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::cli::brew::install(...)
#
#  Args:
#	... - 
#
#>
######################################################################
p6df::core::homebrew::cli::brew::install() {
  shift 0

  p6df::core::homebrew::cmd::brew install "$@"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::cli::brew::services::start(...)
#
#  Args:
#	... - 
#
#>
######################################################################
p6df::core::homebrew::cli::brew::services::start() {
  shift 0

  p6df::core::homebrew::cmd::brew services start "$@"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::cli::brew::services::stop(...)
#
#  Args:
#	... - 
#
#>
######################################################################
p6df::core::homebrew::cli::brew::services::stop() {
  shift 0

  p6df::core::homebrew::cmd::brew services stop "$@"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::remove()
#
#>
######################################################################
p6df::core::homebrew::remove() {

  p6df::core::homebrew::casks::remove
  p6df::core::homebrew::brews::remove

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::core::homebrew::casks::remove()
#
#>
######################################################################
p6df::core::homebrew::casks::remove() {

  local formuli
  formuli=$(p6df::core::homebrew::cmd::brew list --cask)

  local formula
  for formula in ${(f)formuli}; do
    p6df::core::homebrew::cmd::brew uninstall --cask "$formula"
  done
}

######################################################################
#<
#
# Function: p6df::core::homebrew::brews::remove()
#
#>
######################################################################
p6df::core::homebrew::brews::remove() {

  local formuli
  formuli=$(p6df::core::homebrew::cmd::brew list --formula)

  local formula
  for formula in ${(f)formuli}; do
    p6df::core::homebrew::cmd::brew uninstall --ignore-dependencies --force "$formula"
  done
}

######################################################################
#<
#
# Function: p6df::core::homebrew::nuke()
#
#  Environment:	 HOMEBREW_PREFIX
#>
######################################################################
p6df::core::homebrew::nuke() {

  p6_dir_rmrf "$HOMEBREW_PREFIX"
  p6_dir_mk "$HOMEBREW_PREFIX"
}

######################################################################
#<
#
# Function: p6df::core::homebrew::install()
#
#>
######################################################################
p6df::core::homebrew::install() {

  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}
