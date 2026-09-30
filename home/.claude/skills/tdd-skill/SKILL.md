---
name: tdd-skill
description: Test-driven development (TDD). Use when writing or changing production code in a project that works test-first, when the user wants to build features test-first, or when they mention TDD or "red-green-refactor".
---

# Test-Driven Development

TDD is the red (failing test) → green (passing test) → refactor loop. This skill is the reference that makes that loop produce tests worth keeping: what a good test is, the anti-patterns, and the rules of the loop.

## What a good test is

Tests verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't. A good test reads like a specification: "user can checkout with valid cart" tells you exactly what capability exists, and it survives refactors because it doesn't care about internal structure.

A **seam** is the public boundary you test at: the interface where you observe behavior without reaching inside. Tests live at seams, never against internals.

Read a reference file when its step comes up:

- [tests.md](tests.md): when unsure whether a test is well formed.
- [mocking.md](mocking.md): before introducing a test double.
- [refactoring.md](refactoring.md): at the refactor step.

## Anti-patterns

- **Implementation-coupled**: mocks internal collaborators, tests private methods, or verifies through a side channel (querying the database instead of using the interface). The tell: the test breaks when you refactor but behavior hasn't changed.
- **Tautological**: the assertion recomputes the expected value the way the code does (`#expect(add(a, b) == a + b)`), so it passes by construction. Expected values must come from an independent source of truth: a known-good literal, a worked example, the spec.
- **Horizontal slicing**: writing all tests first, then all implementation. Bulk tests verify _imagined_ behavior: you test the _shape_ of things rather than user-facing behavior, the tests become insensitive to real changes, and you commit to test structure before understanding the implementation. Work in **vertical slices** instead: one seam, one test, one minimal implementation, one refactor per cycle, each test a **tracer bullet** that responds to what the last cycle taught you.

## Rules of the loop

- **Red before green.** Write the failing test first, then only enough code to pass it. Don't anticipate future tests or add speculative features.
- **Minimum code to green.** Get there one of three ways (Beck): **Fake It**, return a constant that passes, then refactor the duplication away; **Triangulate**, add a second example that forces the general code; **Obvious Implementation**, write the real code when it's clear, and drop back to Fake It if a test fails unexpectedly.
- **Run the tests yourself, at every step.** Use the test command given in the project's or the user's CLAUDE.md; if neither gives one, ask the user for it. Don't ask the user to run the tests and don't assume the result. After writing the test, run it and confirm it fails on its assertion, not on a typo, a build error, or an unrelated error. After the implementation, run the full suite and confirm it passes. After each refactoring step, run it again. Report the actual output; never claim a result you didn't observe.
- **All generated code must compile or run.** Before handing anything back, test code included, build compiled code and check that scripts load (`python3 -m py_compile`, `perl -c`, `bash -n`) rather than running them for real. `perl -c` still runs `BEGIN` blocks and `use` imports, so a module with load-time side effects runs them. When a test calls a type or function that doesn't exist yet, add an empty placeholder first: the signature with a body that returns a default value (`0`, `""`, `nil`, an empty collection), so the code compiles, or loads in an interpreted language, and the test fails on its assertion. Don't use `fatalError()`, which crashes the whole test run, or `raise NotImplementedError`, which reports an error instead of a failure. If the placeholder's default happens to satisfy the assertion, the test isn't red: return a value the assertion rejects, or check that the test actually exercises the new code. Nothing may be left broken.
- **Changing or deleting an existing test needs the user's confirmation.** Before you delete, disable, or skip a test, or change what it asserts or expects, stop, tell the user which test and why, and wait for confirmation. This holds even when the test looks wrong or is blocking green. Renaming a test or extracting shared setup without changing what it checks doesn't need confirmation.
- **Refactor on green, every cycle.** Once the test passes, remove duplication and clarify names without changing behavior, running the tests after each step. Never refactor on red.
