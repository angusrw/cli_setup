---
name: session-memory
description: Record what a session did into the Obsidian memory vault at ~/repos/memory, so another agent can pick the work up. Use when starting substantive work in a git repo, when reaching a decision or a stopping point worth recording, when handing off mid-task, or when the user asks to save/record/write up what happened. Also use when the user asks what prior sessions did in a repo.
user-invocable: true
argument-hint: "[read | write | handoff]"
---

# Session Memory

An Obsidian vault at `~/repos/memory` holding one note per coding session, in one
folder per repo. It exists so a later agent can pick up work an earlier one left.

This is session narrative — dated, superseded over time. It is **not** the same as
Claude's own memory directory (`~/.claude/projects/*/memory/`), which holds durable
facts about the user and standing project constraints. Do not write there from here.

## Resolve context first

Always start by running the helper. It resolves the repo folder, branch, HEAD,
and this session's pseudonym in one go:

```bash
~/repos/memory/.bin/memctx.sh --session "$CLAUDE_SESSION_ID"
```

If `$CLAUDE_SESSION_ID` is not set, pass the session id from the transcript path,
or omit `--session` and pick any unused adjective-animal name.

It prints `REPO`, `BRANCH`, `HEAD`, `WORKTREE`, `AGENT`, `DIR`, `INDEX`, `DATE`,
`STAMP`. Use those verbatim — do not re-derive paths by hand.

Every worktree and branch of a repo shares one folder. That is deliberate: an agent
in one worktree needs to see what an agent in another did. `branch` and `worktree`
in frontmatter carry the distinction.

## Reading

Read `$INDEX` first — it is one line per note, newest first. Open only the notes
that look relevant. Do not read the whole folder.

Treat notes as reports from the past, not ground truth. Check `head:` against the
current HEAD; if they differ, `git diff <head>..HEAD` shows what moved since.

## Writing

One file per session: `$DIR/$DATE-$AGENT-<slug>.md`, e.g.
`2026-08-10-sage-heron-auth-refactor.md`. The slug is 2-4 words describing the work.

Create the note once you have something worth recording — a decision, a non-obvious
change, a rejected approach. Then keep updating it as the session goes. Do not wait
until the end; sessions get cut off.

```markdown
---
repo: <REPO>
branch: <BRANCH>
worktree: <WORKTREE>
agent: <AGENT>
session: <session id>
started: <STAMP>
updated: <STAMP>
head: <HEAD>
status: active
tags: [refactor]
continues: "[[2026-08-08-amber-vole-auth-spike]]"
---

## Open
- What is in flight, half-done, or the next step. Write this first and keep it current.

## Goal
- What this session set out to do.

## Decisions
- Chose X over Y because Z.

## Changed
- `path/to/file.ts` — what and why, one line.

## Don't
- Approach already tried and rejected, and why. Saves the next agent re-deriving it.
```

Rules:

- **Shorthand, not prose.** Bullets. No narration, no restating the diff.
- **Open goes first** and stays current. It is the section a fresh agent needs and
  the one most likely to get skipped, because the agent writing it already knows.
- **Rationale over record.** Git already stores what changed. Record *why*, and what
  was considered and rejected.
- **`head`** is the repo HEAD at last update. It makes `Changed` checkable.
- **`tags`** — closed set only: `feat`, `fix`, `refactor`, `investigation`, `spike`,
  `chore`. Nothing topical.
- **`continues`** — wikilink to the prior note if this carries on the same thread.
  Omit otherwise.
- **`status`** — `active` while working, `handoff` if stopping deliberately mid-task,
  `done` when finished.

Two agents in one worktree write two separate files. Never edit another session's
note; link to it with `continues` instead.

## The index

After creating a note, and again if its one-line summary changes materially, add or
update its line in `$INDEX` (create the file with an `# <repo>` heading if missing).
Newest first:

```markdown
- [[2026-08-10-sage-heron-auth-refactor]] — swapped token refresh to a background
  worker; `status: handoff`, retry backoff still unwired
```

Keep it to one line: what happened, and anything left open. This is what gets
injected into future sessions, so it carries most of the value.

When the index passes ~40 entries, move `status: done` notes older than a month into
`$DIR/archive/` and drop their index lines.

## Never commit or push

**Do not run `git commit` or `git push` in `~/repos/memory`. Ever. Angus does that
himself.** No exceptions, including when a session ends, when a note is marked
`done`, or when the working tree looks untidy.

Write the note and the index line, then leave them as unstaged changes. That is the
finished state. Say what you wrote; do not offer to commit it.

This applies even if the user has approved a commit elsewhere in the session, and
even if a note says a previous session committed. It did; that was wrong.

## When not to write

Skip trivia. No note for a one-line typo fix, a question answered without touching
code, or work with no decision behind it. An index of noise is worse than no index.
