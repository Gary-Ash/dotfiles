---
name: perl-skill
description: Full Perl 5 development aid. Use when the user wants to create, edit, run, debug, or test Perl scripts and modules (.pl, .pm, .t). Scaffolds files with proper headers, follows modern Perl best practices, executes scripts, and assists with debugging and testing.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: [action or filename]
---

# Perl Development Skill

Assist with all aspects of Perl 5 development including creating files, writing code, running scripts, debugging, and testing.

## Creating New Files

When creating a new Perl file, add the header using `file-header-skill` with its Perl template (shebang and pragmas for `.pl`; pragmas but no shebang for `.pm` and `.t`).

- Make scripts executable: `chmod +x <script.pl>`
- Modules end with `1;` and put POD documentation after `__END__`

## Environment

- Target Perl 5.34, invoked as `#!/usr/bin/env perl`, unless the project specifies otherwise
- Core modules only. Ask before adding a CPAN dependency
- `cpanm` is not installed. If a CPAN module is approved, ask how the user wants it installed
- Global Perl tool config lives under `~/.config/<tool>/`, never as a dotfile in `~`. Point the tool at it with an environment variable in `~/.config/zsh/.zshenv` only if the tool still checks a project-local file first; otherwise pass the path on the command line

## Running and Testing

- Run scripts: `perl <script.pl>`
- Check syntax without executing: `perl -c <script.pl>`
- Include a local lib directory: `perl -Ilib <script.pl>`
- Tests use **Test::More** (core) in `t/*.t`, run with `prove`:
  - All tests: `prove -lv t/`
  - Single file: `prove -lv t/specific.t`
  - Recursive: `prove -lr t/`
- Test file structure:
  ```perl
  use v5.34;
  use strict;
  use warnings;
  use utf8;
  use Test::More;

  use_ok('My::Module');

  is(add(1, 2), 3, 'add sums two numbers');
  is_deeply(parse('a=1'), { a => 1 }, 'parse returns a hash');
  like(report(), qr/done/, 'report mentions completion');

  my $error = eval { divide(1, 0); 1 } ? '' : $@;
  like($error, qr/division by zero/, 'divide dies on zero');

  done_testing();
  ```

## Formatting

- Format with **perltidy**. Honor the project's `.perltidyrc` if present; otherwise perltidy falls back to the global `~/.config/perltidy/perltidyrc` (found via `$PERLTIDY`, set in `~/.config/zsh/.zshenv`):
  ```
  -l=200    line length 200
  -i=4      indent 4 spaces
  -ci=4     continuation indent 4
  -nt       spaces, no tabs
  -nce      uncuddled else: "}" and "else {" on separate lines
  -pt=2     tight parentheses: "foo($x)", no inner spaces
  -utf8     source is UTF-8
  ```
- Write code to match these settings so perltidy produces minimal diffs
- Format in place: `perltidy -b -bext='/' <file>` (no `.bak` left behind)
- Pass only the paths you changed — never run it across the whole tree

## Code Quality

- Always `use strict;` and `use warnings;`
- Declare variables with `my` in the smallest scope
- Three-argument `open` with lexical filehandles, and check the result:
  ```perl
  open my $fh, '<:encoding(UTF-8)', $path or die "Cannot open $path: $!";
  ```
- Use `die` for errors; catch with `eval { ...; 1 } or do { ... }` (don't test `$@` alone)
- Pass references for complex data: `\@list`, `\%hash`; dereference with `->`
- Use `local $_` or named loop variables — don't clobber `$_` in subs
- Avoid bareword filehandles, `&sub` call syntax, and prototypes unless required
- Use `//` (defined-or) for defaults instead of `||` when `0` or `''` are valid
- Use `sprintf`/`printf` for formatted output
- Naming:
  - `snake_case` for subs and variables
  - `PascalCase` for package names (`My::Module`)
  - `UPPER_SNAKE_CASE` for constants (`use constant MAX_RETRIES => 3;`)
- Prefix private subs with `_`

## Script Patterns

### Argument parsing (Getopt::Long, core):
```perl
use Getopt::Long qw(GetOptions);
use Pod::Usage   qw(pod2usage);

my %opt = (verbose => 0);
GetOptions(\%opt, 'help|h', 'verbose|v', 'output|o=s') or pod2usage(2);
pod2usage(1) if $opt{help};
```

### Paths and files (File::Spec, File::Basename, File::Temp — all core):
```perl
use File::Basename qw(basename dirname);
use File::Temp     qw(tempfile);

my ($tmp_fh, $tmp_path) = tempfile(UNLINK => 1);
```

## Debugging

### Built-in
- `use Data::Dumper; local $Data::Dumper::Sortkeys = 1; warn Dumper($ref);`
- `use Carp qw(croak confess);` — `confess` dies with a full stack trace
- `perl -MCarp::Always <script.pl>` if installed; otherwise `perl -MCarp=verbose`
- `perl -W` enables all warnings, including in modules
- Common issues: list vs. scalar context, missing `my`, autovivification, string vs. numeric comparison (`eq` vs `==`)

### perl -d (Perl debugger)
- Launch: `perl -d <script.pl>`
- Key commands:
  - `n` (next), `s` (step into), `c` (continue), `r` (return from sub)
  - `b <line>` or `b <sub>` (set breakpoint), `B <line>` (delete breakpoint)
  - `p <expr>` (print), `x <expr>` (dump structure)
  - `l` (list source), `T` (stack trace), `y` (show lexicals, needs PadWalker)
  - `q` (quit)
- Insert `$DB::single = 1;` in code to break at that point

### perlcritic (static analysis)
- Run: `perlcritic --gentle <file>` (severity 5) through `--brutal` (severity 1)
- Profile: use the project's `.perlcriticrc` if present; otherwise, if `~/.config/perlcritic/perlcriticrc` exists, pass `--profile ~/.config/perlcritic/perlcriticrc`. Don't set `$PERLCRITIC` — it overrides project profiles
- Suppress inline: `## no critic (ProhibitStringyEval)`

## Argument Handling

- If `$ARGUMENTS` is a filename ending in `.pl`, `.pm`, or `.t`, work with that file
- If `$ARGUMENTS` is "new <filename>", scaffold a new file with proper headers
- If `$ARGUMENTS` is "run <filename>", execute the script and report output
- If `$ARGUMENTS` is "test", run `prove -lr t/`
- If `$ARGUMENTS` is "check <filename>", run `perl -c` and perlcritic
- Otherwise, treat `$ARGUMENTS` as a general Perl development request
