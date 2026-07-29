---
name: ste
description: Rewrite or check technical documentation against ASD-STE100 Simplified Technical English (STE) — the controlled English used in aerospace, defence, and technical manuals. Use when the user asks to convert, rewrite, simplify, or check text into Simplified Technical English, STE, ASD-STE100, "simplified english", or a controlled/plain technical language for manuals, procedures, warnings, or maintenance instructions.
user-invocable: true
argument-hint: "[text to rewrite | path to file | 'check' to audit without rewriting]"
---

# Simplified Technical English (ASD-STE100)

Rewrite standard English technical documentation into **ASD-STE100 Simplified Technical
English (STE)**, or audit it against the STE rules without rewriting.

STE is a controlled language for technical documentation. Its goal is text that is
unambiguous, easy to read, and easy to translate — for procedures, descriptions, and
safety information. It works by combining a **Dictionary** of approved words (each with one
meaning and one part of speech) with a set of **writing rules**.

> The authoritative source is the ASD-STE100 specification, published by the AeroSpace and
> Defence Industries Association of Europe (ASD). This skill encodes the widely-documented
> rules and common word substitutions as a working guide — it is not a substitute for the
> official Dictionary. When a project has its own approved Technical Names / Technical Verbs
> list, that list wins.

## Modes

Decide which the user wants:

- **Rewrite** (default) — produce an STE version of the supplied text.
- **Check / audit** — the user says "check", "audit", "does this comply", or "flag issues".
  List violations rule-by-rule and suggest fixes; do **not** silently rewrite.

If the input is a file path, read it. If it is pasted text, work on that. If nothing is
supplied, ask for the text.

## Rewrite process

1. **Identify the writing type.** *Procedural* (instructions the reader performs) vs.
   *Descriptive* (how something works / what it is). The rules and length limits differ.
2. **Segment** into sentences and steps.
3. **Apply the rules below**, in roughly this order: split long sentences → fix verbs and
   voice → swap non-approved words → tighten noun clusters → fix punctuation → reformat
   warnings and lists.
4. **Preserve meaning and all technical facts.** Never drop a safety condition, a value, a
   part name, or a step. If a swap risks changing meaning, keep the technical term and note
   it.
5. **Keep approved Technical Names and Technical Verbs as-is** even if they are not "simple"
   words — e.g. *hydraulic actuator*, *torque*, *de-ice*. STE restricts general vocabulary,
   not the domain's technical terms.

## The core rules

### Words
- Use approved words only. Where a common word is not approved, use the approved
  alternative (see `word-substitutions.md`). Examples: *commence → start*, *utilize → use*,
  *prior to → before*, *in the event that → if*.
- **One word, one meaning.** Do not use an approved word for a meaning it is not approved
  for. E.g. *follow* only means "come after", not "obey" — for that, use *obey* or *do*.
- **One meaning, one word.** Do not use synonyms for the same thing. Pick one term for a
  concept or part and use it everywhere.
- Use a word only as its approved **part of speech**. If *oil* is approved as a noun, do not
  write "oil the bearing" — write "lubricate the bearing with oil".
- Keep **technical names** (nouns/noun phrases naming objects, materials, places) and
  **technical verbs** (manufacturing/maintenance processes like *drill*, *ream*, *solder*).
  These are allowed beyond the core Dictionary.

### Verbs and voice
- Use only approved verb forms: **infinitive**, **imperative**, **simple present**, **simple
  past**, **simple future**, and the **past participle used as an adjective**.
- Do **not** use the **-ing** form (gerund or present participle) unless it is part of a
  technical name (e.g. *packing*, *bearing*). "The pump is failing" → "The pump fails" or
  "The pump becomes defective".
- Do not use compound/complex tenses (no present perfect, no continuous). "You have
  removed" → "You removed". "It is being tested" → "You test it".
- **Procedures: active voice, imperative.** "The valve must be closed" → "Close the valve".
- **Descriptive: prefer active voice.** Passive is allowed only when the doer is unknown or
  irrelevant, or naming the doer is clumsy.

### Noun phrases
- Do not string more than **three nouns** together in a cluster. Break it up with
  prepositions or hyphens and define it. "Runway light connection resistance test" →
  "test of the resistance in the connections of the runway lights".
- Use **articles** (*a*, *an*, *the*) wherever possible. Do not drop them to save space.

### Sentences
- **Length:** procedural sentences ≤ **20 words**; descriptive sentences ≤ **25 words**.
- **One instruction per sentence** in a procedure. Combine two actions only when they are
  done at the same time.
- Put the topic first. State the main message, then the qualification.
- Do not omit words (articles, relative pronouns like *that/which*) to make text shorter.

### Procedures
- Start each instruction with the **command verb** (imperative): "Open the access door."
- Give **conditions before the action**: "If the lamp is on, push the button." not "Push
  the button if the lamp is on."
- Use **vertical (bulleted or numbered) lists** for multiple conditions or actions instead
  of long sentences.

### Warnings, Cautions, and Notes
- A **Warning** = risk of injury/death; a **Caution** = risk of damage; a **Note** = extra
  information.
- Put the warning/caution **before** the step it applies to.
- Start with a clear **command** or a simple statement of the condition, then the
  consequence. "Warning: Do not touch the busbar. The busbar is live and can kill you."
- Keep them specific — say what to do and why.

### Punctuation and layout
- Do not use the slash **/** ("and/or", "on/off") — write *and*, *or*, or reword.
- Prefer full stops over semicolons; keep sentences separate.
- Use hyphens to keep compound modifiers clear.
- Keep **paragraphs to a single topic**; descriptive paragraphs to a maximum of **6
  sentences**. Start with the topic sentence.
- Use consistent spelling (pick one variant, e.g. international or US, and keep to it).

## Output format

**Rewrite mode:**
- Return the rewritten text, ready to use.
- If the change is non-trivial, follow it with a short **"Notes"** section flagging: any
  term you kept because it is a technical name, anything ambiguous you had to interpret, and
  any place where the source meaning was unclear (ask rather than guess on safety-critical
  points).
- For long documents, keep the original structure (headings, step numbers).

**Check mode:**
- A list of findings. For each: quote the offending text, name the rule it breaks, and give
  the STE fix. Group by severity if useful (safety/ambiguity first, style second).
- End with a one-line verdict on overall compliance.

## Don't
- Don't change technical facts, values, tolerances, or part names to make a sentence
  "simpler".
- Don't remove safety information or soften a warning.
- Don't invent an "approved" status for a word you are unsure about — if in doubt, choose a
  plainly common alternative and note it.
- Don't add explanation the source did not contain.
