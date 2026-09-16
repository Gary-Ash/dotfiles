---
name: snippetslab
description: Search, retrieve, and save code snippets and notes in the user's local SnippetsLab library, through the `lab` command-line tool or the snippetslab MCP tools. Use whenever the user mentions SnippetsLab, their snippet library, or saved snippets, and also when they ask whether they have saved, written down, or looked into something before, want to reuse a command, configuration, or procedure they keep, or refer to "my notes" or "my snippets", even without naming the app. For saving, use it only when the user names SnippetsLab or their snippets as the destination, such as "save this as a snippet".
---

# SnippetsLab

SnippetsLab is a macOS app in which the user keeps code snippets and notes. Its command-line tool,
`lab`, reads the library through the running app and, when the user allows it, adds snippets to it.
Use it to consult the library for the task at hand, and search for only what the task needs. Do not
dump the user's whole library.

`lab --help` and each subcommand's help are the reference for syntax, options, defaults, and output.
This skill describes the workflow.

If `lab` is not on the PATH, run it by its full path, for example
`/Applications/SnippetsLab.app/Contents/Helpers/lab`.

## Workflow

1. Search with `--brief`, which returns what identifies each snippet without its content.
2. Choose a result from the titles, folder paths, tags, languages, and the search `context`.
3. Fetch the chosen snippet, then quote, apply, or adapt its content.

For example, for "how did I build clang-format last time?":

```bash
lab search --launch --brief -- "clang-format build"
# Then, with the UUID of the matching snippet from the listing:
lab fetch --launch --format json --snippet E00A071E-CFF1-4D77-AC14-978D9D0C3E34
```

Pass `--launch` so that SnippetsLab starts if it is not running, and put `--` before the query so
that a query beginning with a dash is not read as an option.

## Search

```bash
lab search --launch --brief --limit 20 -- "<query>"
```

The output is JSON. `totalCount` is the number of matches before `--offset` and `--limit`, so it
shows whether the listing is complete. `contentLength` is the combined length of the snippet's
fragment content in UTF-8 bytes, not counting notes. The titles and `context` (the text around the
match) are usually enough to choose. When they are not, repeat the search without `--brief` and
pass `--max-content-length` and `--max-note-length` to skim the candidates. Without `--brief`, the
output is several times larger, so narrow the search first with filters or a smaller `--limit` to
keep the output from filling your context window.

```bash
lab search --launch --limit 10 --max-content-length 500 --max-note-length 200 -- "<query>"
```

To search within a folder, tag, or language, run `lab list --launch filters` first and pass the
`id` values it returns. Folder names can be ambiguous, and a language's display name is not
accepted.

Matching is fuzzy by default: each word of the query matches anywhere in a word, and every word
must match, so a plain query cannot check for alternatives. Pass `--no-fuzzy` to enable additional
syntax. In non-fuzzy mode, search matches whole words by default, and you can use logical operators
AND, OR, and NOT, parentheses for grouping, `*` as a prefix, suffix, or substring wildcard, and
quotes for phrase searches. Run `lab search --help` for the syntax and a link to the full reference
in the manual.

```bash
# Snippets that mention any of several terms
lab search --launch --brief --no-fuzzy -- "*certbot* OR *acme* OR *letsencrypt*"
```

## Fetch

```bash
# Print the whole snippet with metadata and every fragment
lab fetch --launch --format json --snippet <snippet-uuid>
# Print one fragment's content as plain text
lab fetch --launch --snippet <snippet-uuid> --fragment <fragment-uuid>
```

When the snippet's `contentLength` is large, list the fragments first without their notes and
content by passing `--max-output-length 0`, then fetch the fragments you need one at a time:

```bash
lab fetch --launch --format json --max-output-length 0 --snippet <snippet-uuid>
```

Alternatively, pass a larger `--max-output-length <bytes>` to limit the whole output.

Content or a note that ends with `[truncated]` was truncated because of a provided limit. Do not
complete it from context: fetch it in full before quoting, applying, or transforming it.

## Save a snippet

Create a snippet when the user asks to save or keep something in SnippetsLab or as a snippet. Do not
create a snippet on your own initiative, and never for your own working notes.

```bash
# Pick a folder or tags first when they fit. Pass folders by UUID, and tags by UUID or name.
lab list --launch filters
lab create --launch --title "Build clang-format" --folder <folder-uuid> --tag build <<'EOF'
<content>
EOF
```

The content is read from standard input. The quoted heredoc passes it to `lab` without shell
expansion. Give the snippet a clear title, and put any explanations in `--note` instead of the
content. Set `--language` to the content's language, by alias such as `swift`, or by the `id` from
`lab list filters`. Use `markdown` for prose and documentation. The output is JSON with the new
snippet's `uuid`, `title`, and `tagsCreated`.

`lab create` works only when the user has enabled write access in **SnippetsLab Settings >
Integrations > AI Agents & Command Line Tools**. When the command reports that write access is off,
tell the user where to turn it on and do not retry. Report any other error, such as no open library,
to the user.

## Link to the source

When quoting or adapting library material, or when the user asks where something lives, include a
Markdown link that opens it in SnippetsLab, in the fragment form when one fragment was used:

```text
snippetslab://snippet/<snippet-uuid>
snippetslab://snippet/<snippet-uuid>/<fragment-uuid>
```

If the client cannot open custom URL schemes, the user can run `open <link>` in a shell. Include the
link together with the content the user asked for.

## Use the MCP tools when available

`lab mcp` serves the same library over the Model Context Protocol. When the `snippetslab` MCP server
is configured, prefer it over the CLI, as it is optimized for token efficiency and clients can allow
the read-only tools without prompting the user. The workflow is the same.

| Command                             | Tool                              |
| ----------------------------------- | --------------------------------- |
| `lab search --brief`                | `search_snippets`                 |
| `lab search` with length limits     | `search_snippets` with `verbose`  |
| `lab fetch --format json`           | `get_snippet`                     |
| `lab list filters`                  | `list_filters`                    |
| `lab info`                          | `info`                            |
| `lab create`                        | `create_snippet`                  |

`get_snippet` has an output limit of its own and adds a note to the result when it truncates
anything. Set `ignore_size_limit` to read a snippet in full.

## Handle failures

Data is on standard output, diagnostics are on standard error, and a nonzero exit status means
failure. If neither `lab` nor its full path is found, or the tool cannot reach SnippetsLab, explain
and point the user to **SnippetsLab Settings > Integrations > AI Agents & Command Line Tools**,
which contains setup instructions. Do not look for the library on disk or read SnippetsLab's files
directly.
