---
name: policy-mapping
description: >
  Use this skill whenever the user wants to break down, analyse, or extract structured criteria from
  policy documents, regulations, standards, or guidance. This includes: turning a regulation into a
  checklist, extracting requirements from a policy framework, identifying what a standard mandates,
  structuring guidance into actionable criteria, mapping obligations from legislation, or building an
  assessment framework from a document. Trigger on phrases like "break this down", "extract the
  requirements", "what does this standard require", "turn this into criteria", "itemise this policy",
  "what are the obligations in", "analyse this guidance", "create a compliance checklist from", or
  whenever the user pastes or references a policy, standard, regulation, or guidance document and wants
  to understand or structure its requirements. Use this skill even if the user doesn't say "criteria"
  explicitly — if they're trying to make sense of a complex policy or regulatory document in a
  structured way, this is the right skill.
---

# Policy Criteria Breakdown Skill

This skill helps you extract structured, itemised criteria from any policy document, regulation,
standard, or guidance — making complex requirements clear, consistent, and easy to work with.

## When you receive a request

### Step 1: Understand the context

Before diving in, take stock of:
- **What document** is being analysed (pasted text, uploaded file, named standard, URL, etc.)
- **What the user wants to do** with the criteria (assess compliance, draft policy, evaluate suppliers, brief colleagues, etc.) — if not stated, make a reasonable inference and proceed; don't hold things up asking
- **Any specific attributes or categorisation** the user has requested

If the document hasn't been provided, ask for it. If the purpose is ambiguous but you can make a reasonable start, do so — you can always refine.

### Step 2: Clarify attributes (only if needed)

The default attribute set (below) works well for most situations. Use it unless:
- The user has specified something different
- The document type makes certain attributes clearly irrelevant (e.g. a technical standard may not have "who it applies to" differentiation)
- You're unsure which compliance vocabulary fits the document

In those cases, briefly flag what you're doing and why — don't ask a long series of questions before producing anything.

### Step 3: Read the document carefully

Work through the full document systematically. Policy and regulatory documents often bury requirements in:
- Definitions sections (which constrain what other clauses mean)
- Annexes and appendices
- Cross-references to other standards
- Apparently narrative or explanatory passages that contain embedded obligations

Don't just skim headings — read for substance. Identify every distinct, actionable criterion.

### Step 4: Extract and structure the criteria

For each criterion you identify:
- Write it as a **clear, standalone, actionable statement** — not a quote from the document, but a well-formed expression of the requirement that could stand alone in a checklist or assessment
- Assign each criterion a **unique reference ID** (e.g. C001, C002…) for traceability
- Apply the relevant attributes (see below)
- Group and order them logically

If a passage contains multiple distinct requirements, split them into separate criteria. If a requirement is conditional (e.g. "if processing personal data, then…"), capture the condition as part of the criterion.

---

## Default attributes

Apply these to each criterion unless the user requests a different set. The goal is not to be mechanical about it — use judgment, and omit or adapt attributes where they don't add value.

| Attribute | What it captures | Examples |
|-----------|-----------------|---------|
| **ID** | Unique reference | C001, C002 |
| **Criterion** | Clear statement of the requirement | "The organisation must appoint a named data protection officer" |
| **Source** | Where in the document this comes from | Section 3.2, Annex A, Article 5(1)(a) |
| **Obligation level** | How strongly the requirement is stated | Mandatory / Required / Recommended / Optional / Conditional |
| **Theme / category** | The topic area it belongs to | Governance, Data handling, Access control, Reporting |
| **Applies to** | Who or what the criterion governs | All organisations / Processors only / Systems handling PII / etc. |
| **How to demonstrate** | What evidence or action would show the criterion is met | "Written policy in place", "Technical control implemented", "Named individual designated" |
| **Notes** | Caveats, dependencies, or links to related criteria | "See also C014 re: data retention" |

### Obligation level guidance

Use the document's own language to determine obligation level. Common conventions:
- **Mandatory**: MUST, shall, is required to, must not
- **Required**: should, is expected to, is required (softer framing)
- **Recommended**: it is recommended, best practice suggests, ideally
- **Optional**: may, can, is encouraged to
- **Conditional**: if [condition], then [requirement] — note both the condition and the obligation

If the document uses a different framework (e.g. RAG ratings, tiered compliance levels, pass/fail), use that instead and note it.

---

## Output format

Produce output in **markdown** by default. Structure it as follows:

```
# Criteria breakdown: [Document name]

## Summary
Brief overview of the document's scope, purpose, and total number of criteria extracted.
[Optional: note any significant ambiguities or things not extracted and why]

## Criteria

### [Theme / category name]

| ID | Criterion | Source | Obligation | Applies to | How to demonstrate | Notes |
|----|-----------|--------|------------|------------|-------------------|-------|
| C001 | ... | ... | Mandatory | ... | ... | ... |
| C002 | ... | ... | Recommended | ... | ... | ... |

### [Next theme]
...

## Attribute key
[Brief legend explaining obligation levels and any document-specific categorisation used]
```

If the user has requested a different output (table in Word, Excel, plain list, etc.), adapt accordingly — the structure above is the default, not a constraint.

### Adapting the format to the document

- For **short or simple** documents: a single flat table may work better than grouping by theme
- For **very long** documents: consider a summary table of themes first, then detail tables per theme
- For **highly technical** standards (e.g. ISO, NIST): preserve the original section numbering in the Source field so criteria can be traced back easily
- For **legislation**: distinguish between duties on different parties (e.g. data controllers vs processors, public authorities vs private bodies)

---

## Quality checks before outputting

Before finalising, ask yourself:
- Is every criterion **actionable and standalone** — could someone assess against it without needing the original document?
- Have I covered the **whole document**, not just the obvious headings?
- Are the obligation levels **consistent with the document's own language**?
- Have I **split** combined requirements rather than bundling multiple obligations into one criterion?
- Are the themes **intuitive** — would a reader group these the same way?
- Is anything **missing or ambiguous** that the user should be flagged on?

---

## Variations and edge cases

**When the document is very long**: Work section by section and tell the user as you go. It's better to produce accurate criteria for each section than to rush and miss things.

**When the document cross-references other standards**: Note the cross-reference in the Source or Notes field. Don't try to import criteria from the other document unless the user asks.

**When obligation language is ambiguous**: Flag it — e.g. "Note: the document says 'organisations should consider' — this has been classified as Recommended but may be interpreted as stronger in practice."

**When the user wants to customise attributes**: Accept any attribute set the user specifies. Common alternatives include: RAG status, Priority (High/Medium/Low), Owner/responsible party, Implementation effort, Deadline/effective date.

**When the user asks for comparison across documents**: Produce a unified criteria table with a "Source document" attribute column added, and flag where documents overlap or conflict.
