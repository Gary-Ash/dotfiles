---
name: commit
description: Generate Git commit messages following project conventions. Use when the user wants to commit changes or asks for a commit message. Analyzes staged/unstaged changes and produces properly formatted commit messages with tags, Title Case summaries, and prose bodies.
allowed-tools: Read, Bash, Grep, Glob
argument-hint: [description of changes]
---

# Git Commit Message Skill

Generate and create Git commit messages following the project's strict formatting rules.

## Commit Message Format

```
[TAG] Title Cased Short Summary

Detailed description of the change, written in prose and wrapped at
72 characters.
```

## Tags

- `[BUG FIX]` = A bug fix
- `[FEATURE]` = New feature code
- `[REFACTOR]` = A code refactor
- `[TEST CODE]` = Added test code
- `[TIDY]` = A tidy up action such as reformatting or spelling fixes

## Special Case

If this is the very first commit of a project (no prior commits exist), the entire commit message must be exactly:

```
Initial commit
```

No tag, no body.

## Summary Line Rules

- Must begin with a tag in square brackets (except "Initial commit")
- Must be Title Cased
- Must be short and concise
- Must NOT end with a period

## Body Rules

- One blank line between the summary line and the body
- Body must be written in prose (complete sentences, paragraph form)
- Body must NOT use bullet points or lists
- Wrap all lines at 72 characters

## Workflow

1. Run `git status` to see what has changed
2. Run `git diff --cached` to see staged changes; if nothing is staged, run `git diff` to see unstaged changes
3. Check `git log --oneline -1` to determine if this is the first commit (if it errors, it is the first commit)
4. Analyze the changes to determine the appropriate tag and write a clear summary and description
5. Check for a README file at the repo root (`README.markdown` (preferred), `README.md`, `README`, `README.rst`, `README.txt`). If one exists, read it and determine whether the changes make any part of it stale or incomplete (features added/removed, usage changed, install steps, options, file layout, etc.). If so, update the README in the same commit. If the README is unaffected, proceed without changes.
6. Stage files if needed (prefer staging specific files over `git add -A`)
7. Create the commit using a HEREDOC for the message:
   ```
   git commit -m "$(cat <<'EOF'
   [TAG] Title Cased Short Summary

   Detailed description of the change.
   EOF
   )"
   ```

## Argument Handling

- If `$ARGUMENTS` is provided, treat it as a description of the changes to help craft the commit message
- If no arguments, analyze the diff to determine the appropriate message
- Always review the actual changes before committing — do not rely solely on the user's description
