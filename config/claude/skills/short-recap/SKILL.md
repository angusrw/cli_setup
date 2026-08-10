---
name: short-recap
description: Recap the current session as two short bullet lists — where the project stands now, and what changes have been agreed or discussed. Use when the user asks "where are we", "short recap", "catch me up", "what have we agreed", "summarise this conversation", or wants a status check before handing off or resuming work. Not for summarising git history — use git-recap for that.
user-invocable: true
argument-hint: "[optional focus, e.g. 'just the decisions' | 'for a handover note']"
---

# Recap

Produce a two-part recap of the current session:

1. **Status** — where the project actually stands right now.
2. **Agreed / discussed** — what changes have been decided or debated in this conversation.

Each list is **at most 6 bullets**. Fewer is fine. Never more.

## Sources

The conversation is the primary source. Check it against reality before asserting anything:

- If the working directory is a git repo, run `git status --short` and `git diff --stat` (plus
  `git log --oneline -5` if useful) to confirm what has actually changed on disk versus what was
  merely proposed.
- Do not re-explore the codebase, re-read files, or spawn agents. A recap summarises what is
  already known — it is not a fresh investigation.
- If no work has happened yet (discussion only), say so in one line rather than inventing status.

## Status bullets

What is true *now*:

- What is done and verified — say what proved it (tests passed, output checked, file written).
- What is done but unverified — say that plainly.
- What is in progress or half-finished, and where it stopped.
- What is blocked, and on what.

Do not list things that were merely planned. Those belong in the second list.

## Agreed / discussed bullets

Decisions and proposals from this conversation:

- Mark anything not settled: prefix with `Discussed:` or add `— not decided`.
- Include decisions to *not* do something, and approaches the user rejected. Those are the
  easiest to lose and the most costly to relitigate.
- Attribute the call when it matters: a choice the user made is firmer than one you suggested.
- Include the reason only when the decision would be reversed without it.

## Output format

Two labelled lists, nothing else. No preamble, no closing offer.

```
**Status**
- …

**Agreed**
- …
```

Rules:

- One line per bullet. If it needs two lines, it is two bullets or the wrong detail.
- Rename the second heading to `**Agreed / discussed**` when the list is mostly unsettled items.
- Merge related points rather than dropping them silently. If more than 6 real items exist in a
  list, combine the smallest ones and keep the cut visible — never truncate without saying so.
- If a list would be empty, write `- Nothing yet.` rather than omitting the heading.
- No commit hashes, file dumps, or code blocks unless the user asks.

## Arguments

An argument narrows the recap: `just the decisions` → drop the status list; `for a handover note`
→ write for someone with no context, expanding names and acronyms. With no argument, produce both
lists.

## Don't

- Don't restate the user's requests back as status.
- Don't pad to 6 bullets. Three accurate bullets beat six with filler.
- Don't add next steps, recommendations, or open questions — this skill reports, it doesn't plan.
