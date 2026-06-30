---
name: git-recap
description: Summarize recent changes in the current local git repository as a concise bullet list, including merged branches and PRs. Use when the user wants to catch up on what's happened in a repo, asks for a recap, summary of recent commits, or "what's been going on" in a repo.
user-invocable: true
argument-hint: "[N commits | time window e.g. '1 week' | --since=YYYY-MM-DD]"
---

# Git Recap

Summarize recent activity in the current git repository as a tight bullet list.

## Argument parsing

- Pure integer (e.g. `20`) → last N commits: `git log -n <N>`
- Time expression (e.g. `1 week`, `3 days`, `yesterday`) → `git log --since="<expr>"`
- `--since=…` passed through verbatim
- No argument → default to last 15 commits

If you can't tell which form was given, ask the user once rather than guessing.

## Pre-flight

1. Confirm cwd is a git repo: `git rev-parse --is-inside-work-tree`. If not, stop and tell the user.
2. Note the current branch: `git rev-parse --abbrev-ref HEAD` — useful context for the recap header.

## Gather (run independent commands in parallel)

A single `git log` rarely tells the whole story. Pull from several views and reconcile:

- **Full commit list in range** — `git log <range> --pretty=format:"%h %an %ar | %s"`
- **Merges only** — `git log <range> --merges --pretty=format:"%h | %s"` to extract merged branches / PRs
- **First-parent (mainline) view** — `git log <range> --first-parent --pretty=format:"%h | %s"` to see the "headline" changes if the history is heavily branched
- **Tags/releases in range** — `git log <range> --simplify-by-decoration --pretty=format:"%h %d %s"` to spot version bumps
- **Files touched** — `git log <range> --name-only --pretty=format:"%h"` *only* if the commit messages are vague and you need to infer what changed

For merge commit subjects, extract the branch name:
- `Merge branch 'feat/foo'` → branch `feat/foo`
- `Merge pull request #123 from owner/branch` → PR #123 from `owner/branch`

## Output format

Plain bullet list. No headers, no preamble beyond a one-line context line if useful (branch + range). Each bullet is one line, present tense, paraphrased — not a copy-paste of the raw subject.

- Group thematically when there's a clear cluster (e.g. "several commits cleaning up the auth module"); otherwise chronological, newest first.
- Call merges out explicitly: `Merged `feat/foo` into main` or `Merged PR #123 — short description`.
- Mention tags/releases inline where they fall.
- Omit commit hashes unless the user asks.
- Skip noise: pure formatting commits, "wip", reverted-then-reapplied churn — unless that *is* the story.

Keep it terse. A 30-commit window should land in ~10–15 bullets, not 30.

## Don't

- Don't run `git fetch` or any network operation — this is a local recap.
- Don't speculate about *why* something was done beyond what the commit message says.
- Don't include diffs unless the user explicitly asks.
