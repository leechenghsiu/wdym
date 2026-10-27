# wdym — native Mac prototype

Installed at `~/Applications/WDYM.app`. Requires Apple silicon, macOS 26+, enabled Apple Intelligence and the downloaded on-device model. This Mac reports the model as available.

## Use

- The `wdym?` text in the macOS menu bar is the entry point. Click to show/hide the floating panel.
- Drag selected text onto the menu-bar item, the blank underline, or the panel. Native plain text and RTF are accepted. The source app must support native text drag; some terminals do not.
- Click the menu-bar item to open and focus the editable sentence. Type or press Cmd+V to insert text; Return asks. The clipboard button immediately pastes and explains.
- The sentence shows a short quotation. “View original” reveals the whole input.
- The UI, menus, tooltips, errors, and model instructions are English. Original dropped text is preserved in its original language. Answers always request English.
- Answers stream from Apple's on-device Foundation Models. No API key, model server, FMChat dependency, cloud fallback, analytics or account is used.
- The reset icon clears/cancels. Copy copies only the answer. Close hides the panel; right-click the menu item and choose “Quit wdym” to quit.

The app does not read other windows, monitor selection, watch the clipboard, save history, register login items or request Accessibility permission. Clipboard text is read only after an explicit paste action. An unavailable model or a generation error is shown in the panel. Answers can be incorrect, especially for project-specific terms without context.

## Build

```sh
./build.sh
open build/WDYM.app
```

Native AppKit + SwiftUI + FoundationModels; no package dependencies. The app is ad-hoc signed for this local prototype, not a notarized distribution. The installed bundle is approximately 444 KB; model memory and storage are managed separately by macOS.

## Verification

- `swiftc` release build and ad-hoc signature completed.
- `WDYM --model-status`: `available — Apple on-device model`.
- A real UI paste of “race condition 是什麼？” produced a streamed Traditional Chinese response; no prewritten explanation path exists in native code.
- `Tests/CoreTests.swift` passes input validation, quotation abbreviation, and stale-request rejection checks.
- Native drag harness remains in `Tests/DragHarness.swift`. UI automation started a native drag but did not reliably complete the release; the user subsequently confirmed that dragging text into wdym produced an explanation. The automated harness itself is not counted as passed.

The former browser prototype is retained in `../dist/` for reference; its server has been stopped. It is not needed by this app.

## Build 2 — English

All app-owned UI and prompts are English. A real Chinese input (“什麼是 cache？”) produced an English response in the installed app. No Chinese UI strings remain in Sources/. The on-device model is intended for short explanations and can still give incorrect technical definitions; model confidence is not verification.

## Build 3 — app icon

Warm paper tile with a dark Baskerville italic w and blue question mark. Generated from editable native drawing code in `Assets/GenerateIcon.swift`, rendered at all standard macOS icon resolutions, and packaged as `AppIcon.icns`. Bundle and runtime application icons are both set.

## Build 4 — square monogram

The icon now uses all four letters in two lines: wd / ym, with the same cream tile and dark italic type. Re-rendered at all icon sizes, installed and re-registered with Launch Services.

## Build 7 — native text entry and link hover

The sentence blank is now an editable, automatically focused TextField. Return submits. Native text drop remains supported through the field drop handler and the full-panel AppKit destination. Cmd+V uses native paste while the field editor is active; the separate clipboard action still asks immediately. The documentation link underlines on hover. Menu-bar item width is measured from its title instead of fixed at 64 points. Native UI checks confirmed typing, paste without premature generation, and Return-to-English-answer.

## Build 8 — hide on blur

The floating panel orders itself out when it resigns key status and hides when the app deactivates. Installed build verified by opening the panel, moving focus to Finder, and checking the visible-app inventory without reactivating wdym.
