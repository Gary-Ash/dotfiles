# Project Guidelines for Claude

## Development Approach

- Test-Driven Development (Kent Beck style)
  1. Write a failing test

  2. Make it pass with minimal code

  3. Refactor (tidy)

  4. NEVER delete or comment out a test without my approval

- Tidy First: small structural changes before behavior changes

- Prefer small, focused commits that do one thing

## Languages

- Swift: primary
  - Xcode and Swift Package Manager only (no CocoaPods, Carthage, etc.)
- Perl: primary
- C++: performance-critical work
  - Modern C++ (C++20), memory-safe idioms (smart pointers, RAII, no raw new/delete)
  - CMake only, cross-platform (no platform-specific APIs without abstraction)
  - Always build with sanitizers (ASan, UBSan) during development

## File Headers

- Always use the `file-header-skill` when creating new source files
- When editing a file that has a header, always update the Modified timestamp to the current date/time

## Testing

- Tests come first
- Each commit should leave tests passing
- Separate refactoring commits from behavior-changing commits
