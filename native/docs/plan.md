# Native WDYM — 2026-10-28

User approved replacement of the web UI with a tiny Mac menu-bar utility, using Apple Foundation Models on-device, without API keys or cloud fallback. The Mac reports SystemLanguageModel.default.availability == available.

Design: a text status item `wdym?` accepts native text drops directly. Clicking opens a small floating panel with only `wdym ____?`. It also accepts text drops and supports paste as a fallback. On drop, the original completes the sentence and a streamed explanation appears below it. Long originals are abbreviated and expandable. No global selection monitoring, Accessibility permission, login, analytics, browser, or conversation scraping. Right click status item for paste/show/quit. Reopen is available through the status item. No auto-launch preference added.

Model: a fresh on-device session per request, concise Traditional Chinese explanation, no tools; dropped content is treated as quoted material. Availability checked for each request. Explicit model-not-ready / Apple Intelligence disabled / unsupported hardware and generation error states. Cap source size and cancel/reject stale generations on a new request or clear. No disk persistence except explicit copying of an answer by the user.

Implementation and verification:
- [x] Test text validation, long quotation display, and request identity cancellation before UI implementation.
- [x] Build AppKit status-item drag destination and SwiftUI panel, native frameworks only.
- [x] Run actual model inference and native paste/streaming.
- [x] User confirmed: dragging text into wdym produced an explanation. Automated drag-release remains a harness limitation.
- [x] Leave the native app running; stop the old web prototype server and label retained web files as superseded.
