---
name: bash-skill
description: Full Bash development aid. Use when the user wants to create, edit, run, debug, or test Bash shell scripts. Scaffolds files with proper headers, follows Bash best practices, executes scripts, and assists with debugging.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: [action or filename]
---

# Bash Development Skill

Assist with all aspects of Bash script development including creating files, writing code, running scripts, debugging, and testing.

## Creating New Files

When creating a new Bash script, always add the header using `file-header-skill` with its Bash template. Every script must begin with:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

After creating a file, make it executable: `chmod +x <script.sh>`

## Running and Testing

- Run scripts with: `bash <script.sh>` or `./<script.sh>`
- Check syntax without executing: `bash -n <script.sh>`
- Run with debug tracing: `bash -x <script.sh>`
- Use `shellcheck <script.sh>` for static analysis
- Tests use `bats` (bats-core, required) in `test/*.bats`; run with `bats test/`

## Code Quality

- Always use `set -euo pipefail` at the top of scripts:
  - `-e`: exit on error
  - `-u`: error on undefined variables
  - `-o pipefail`: catch errors in piped commands
- Quote all variable expansions: `"${variable}"` not `$variable`
- Use `[[ ]]` for conditionals instead of `[ ]`
- Use `$(command)` instead of backticks for command substitution
- Use `local` for variables inside functions
- Use `readonly` for constants
- Use snake_case for variable and function names
- Use UPPER_SNAKE_CASE for exported environment variables
- Prefer `printf` over `echo` for portable output
- Always handle the case where commands fail gracefully

## Script Patterns

### Argument parsing:
```bash
usage() { printf 'Usage: %s [-h] [-v] [args...]\n' "${0##*/}"; }

verbose=false
args=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage; exit 0 ;;
        -v|--verbose) verbose=true; shift ;;
        *) args+=("$1"); shift ;;
    esac
done
if [[ "${verbose}" == true ]]; then
    printf 'Verbose mode on\n' >&2
fi
```

### Cleanup on exit:
```bash
cleanup() {
    rm -f "${tmp_file:-}"
}
trap cleanup EXIT
```

### Logging:
```bash
log() { printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >&2; }
```

## Debugging

### Built-in Bash debugging
- Use `set -x` to trace execution (or `bash -x script.sh`)
- Use `PS4='+(${BASH_SOURCE}:${LINENO}): '` for detailed trace output
- Use `set -E` with `trap 'printf "Error on line %s\n" "$LINENO" >&2' ERR` for error location; without `set -E`, functions don't inherit the ERR trap
- Check for common issues: unquoted variables, missing error handling, word splitting

### ShellCheck (static analysis)
- Run `shellcheck <script.sh>` to catch bugs, style issues, and portability problems
- Use `shellcheck -s bash` to explicitly target Bash
- Use `shellcheck -e SC2086` to exclude specific rules
- Use `shellcheck -f diff` to get machine-applicable fix suggestions
- Add inline directives to suppress warnings: `# shellcheck disable=SC2086`

### bashdb (Bash debugger)
- Interactive debugger for Bash scripts, similar to gdb
- Launch with: `bashdb <script.sh>`
- Key commands:
  - `n` (next), `s` (step into), `c` (continue)
  - `b <line>` (set breakpoint), `clear <line>` or `d <n>` (delete breakpoint by line or by number)
  - `p <expr>` (print expression), `x <expr>` (examine)
  - `l` (list source), `w` (where/backtrace)
  - `q` (quit)
- Install with: `brew install bashdb`

### bats-core (Bash Automated Testing System)
- TAP-compliant testing framework for Bash
- Install with: `brew install bats-core`
- Test files use `.bats` extension
- Run tests with: `bats test/` or `bats test/script.bats`
- Test structure:
  ```bash
  @test "description of test" {
      run my_function arg1 arg2
      [ "$status" -eq 0 ]
      [ "$output" = "expected output" ]
  }
  ```
- Helper libraries:
  - `bats-support` -- common assertions and output formatting
  - `bats-assert` -- advanced assertion functions (`assert_success`, `assert_output`, `assert_line`)
  - `bats-file` -- file system assertions (`assert_file_exists`, `assert_dir_exists`)

## Argument Handling

- If `$ARGUMENTS` is a filename ending in `.sh`, work with that file
- If `$ARGUMENTS` is "new <filename>", scaffold a new file with proper headers and make it executable
- If `$ARGUMENTS` is "run <filename>", execute the script and report output
- If `$ARGUMENTS` is "check <filename>", run shellcheck and syntax validation
- Otherwise, treat `$ARGUMENTS` as a general Bash development request
