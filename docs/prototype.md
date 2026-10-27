# wdym interaction prototype — 2026-10-28

Approved scope: a local web prototype, rather than a native Mac app. The sentence `wdym ____?` is the drop target. Dropped text completes the sentence and opens an explanation underneath. Long text becomes a short quotation with the full original available. Cross-window text drag and a keyboard/paste fallback are supported.

The first version is explicitly an interaction demo: curated explanations for example phrases, honest fallback for arbitrary input, no model calls or uploads. No credentials, remote persistence, accounts, or deployment. Warm paper, ink typography and one blue accent. Animations honor Reduce Motion.

Implementation checklist:
- [x] Test plain-text intake, long-input validation, example selection, and export.
- [x] Build standalone HTML/CSS/JS, with an exclusive current request so old timers cannot overwrite new drops.
- [x] Verify in browser: actual drag/drop, paste, keyboard, long text, reset, narrow view and Markdown download; include Reduce Motion CSS guards.
- [x] Serve locally and leave the interactive preview open.
