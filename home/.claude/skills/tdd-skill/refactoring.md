# Refactoring

Refactoring is the third step of the cycle: red → green → refactor. Green makes it work; refactoring makes it right. It changes structure, never behavior, and the tests stay green throughout.

## When

- **Only on green.** If you are red, get to green first (with Fake It if you must), then refactor.
- **Before a change that is hard.** Make the change easy, then make the easy change (Beck). If a new test would be awkward to pass, refactor first while you're still green, then write the test. If you're already red, get to green first; backing out the failing test to refactor first counts as deleting a test and needs the user's confirmation (see *Rules of the loop* in [SKILL.md](SKILL.md)).

## Two hats

You are either adding behavior or restructuring, never both at once (Beck, via Fowler).

- **Behavior hat**: write a failing test, make it pass. No structural cleanup.
- **Structure hat**: change structure, add no behavior, change no test expectations.

When committing, structure changes and behavior changes are separate commits, structure first (Tidy First).

## What "right" means: simple design

Beck's rules of simple design, in priority order:

1. Passes the tests.
2. Reveals intention: names say what things are for.
3. No duplication: every idea is expressed once and only once.
4. Fewest elements: nothing that isn't needed for rules 1–3.

Stop refactoring when the code satisfies these.

## Remove duplication between test and code

The main refactoring in TDD is removing the duplication that Fake It (returning a constant that passes) creates between the test and the code.

```swift
// Test
@Test("multiplying a dollar amount")
func multiplication() {
    #expect(Dollar(amount: 5).times(2).amount == 10)
}

// GREEN: faked. The 10 duplicates data in the test (5 × 2).
struct Dollar {
    let amount: Int
    func times(_ multiplier: Int) -> Dollar {
        Dollar(amount: 10)
    }
}

// REFACTORED: duplication removed, test still green
struct Dollar {
    let amount: Int
    func times(_ multiplier: Int) -> Dollar {
        Dollar(amount: amount * multiplier)
    }
}
```

## Mechanics

- **Tiny steps.** One transformation at a time (rename, extract, inline, move). If a step breaks a test, undo it rather than debugging forward.
- **Tests are code too.** Refactor test duplication and names the same way, but never in the same step as production code, and never weaken an assertion to do it.
- **Small tidyings first** (Beck, *Tidy First?*): guard clauses, dead-code deletion, explaining variables and constants, reading order, putting related code together. They are cheap, safe, and make the larger change visible.
- **Stop when it's clear enough.** Refactoring serves the next change, not perfection.

## Anti-patterns

- **Hidden behavior change**: a "refactor" that needs a test expectation changed is a behavior change. Switch to the behavior hat and write a test.
- **Big-bang rewrite**: long stretches without getting back to green. If you can't get back to green quickly, revert.
- **Skipping the step**: going straight from green to the next red. The duplication stays in the code and gets more expensive with each cycle.
