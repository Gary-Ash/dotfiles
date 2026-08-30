# Git Commit Skill

Create well-formatted git commits following conventional commit standards.

## Usage
```
/commit
```

## Behavior
1. Analyze staged changes with `git diff --staged`
2. Generate a conventional commit message
3. Create the commit with proper formatting

## Commit Format
The Initial commit should be called that Initial commit

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

## Types

[FEATURE]: 	New feature
[BUG FIX]: 	Bug fix
[TIDY]: 	Documentation changes, Code style changes,
[REFACTOR]: Code refactoring
[TEST]: 	Adding or modifying tests

## Example Output
```
[FEATURE]: Add Password Reset Functionality

- Add forgot password form
- Implement email verification flow
- Add password reset endpoint
```
