> Current prototype: the native menu-bar app in [native/](../native/README.md), installed at `~/Applications/WDYM.app`. The web prototype below is retained for reference and its server is stopped.

# wdym?

Local, buildless interaction prototype. Drag plain text into `wdym ____?`; it becomes a question and opens a small explanation card.

## Run

```sh
cd wdym
npm start
```

Open http://127.0.0.1:8788. No package installation is required (Node.js for the test command, Python 3 for the static server).

## Try

- Drag one of the three example chips into the underline, or click a chip.
- Drag selected text from another app that supports native text drag. The browser must remain visible; this prototype is not a global Mac drop target.
- Click the underline or “也可以貼上” for manual entry. Cmd/Ctrl+Enter submits.
- Paste directly onto the page outside a text field to ask about the clipboard text.
- Long text is abbreviated in the sentence; the original is retained under its disclosure.
- “舉個例子” expands a concrete example. “Keep as .md” downloads the original and demo explanation; “換一句問” resets.

## Deliberate prototype boundary

There are three curated explanations: shared browser session, race condition and context compaction. Arbitrary text is accepted, but gets an explicit not-connected-to-AI message. No model, API key, upload, account, analytics, browser storage, or remote service is used. Content disappears on refresh unless you download it. Source URLs and surrounding conversation are not available from a plain-text drop.

## Validation

`npm test`: three tests covering text intake, known/unknown demo matching, and lossless original export with demo disclosure. `node --check dist/app.mjs` checks JavaScript syntax.

Native browser QA confirmed actual chip drag/drop, rapid replacement, keyboard submission, long text, safe literal rendering of markup, original disclosure, example expansion, Markdown download, reset, empty-input feedback, and no horizontal overflow at 320px (empty and long-result states) and 1100px. Browser warning/error log was empty. CSS includes Reduce Motion guards; OS preference was not changed for testing. Cross-app drag depends on the source app and has not been individually tested across coding-agent clients.

`preview-answer.png` shows the rendered result. The animation primitives in `dist/transitions.css` are sourced from the installed transitions-dev skill.
