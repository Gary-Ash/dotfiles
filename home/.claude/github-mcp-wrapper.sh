#!/usr/bin/env bash
set -euo pipefail
#*****************************************************************************************
# github-mcp-wrapper.sh
#
# Launches the GitHub MCP server with a token fetched at runtime from the macOS
# Keychain via the gh CLI, avoiding plaintext token storage in config files.
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  23-Feb-2026  2:30pm
# Modified :
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************

export GITHUB_PERSONAL_ACCESS_TOKEN="$(gh auth token)"
exec /opt/homebrew/bin/github-mcp-server stdio --read-only --toolsets gists,repos,users
