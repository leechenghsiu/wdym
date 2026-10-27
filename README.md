# wdym?

A tiny native Mac app for words you don't understand. Drag selected text onto **wdym?** in the menu bar, or type a question, to get a quick explanation without interrupting your conversation.

Runs locally with Apple Foundation Models. No API key, server, cloud fallback, or account.

## Requirements

- Apple silicon Mac with macOS 26 or later
- Apple Intelligence enabled and its on-device model downloaded
- Xcode with the macOS 26 SDK or later to build

## Build and run

```sh
./native/build.sh
open native/build/WDYM.app
```

The build is ad-hoc signed for local use. The installed copy at `~/Applications/WDYM.app` is separate from this checkout.

## Test

```sh
xcrun swiftc -parse-as-library native/Sources/Core.swift native/Tests/CoreTests.swift -o /tmp/wdym-core-tests
/tmp/wdym-core-tests
```

See [native documentation](native/README.md) for behavior and verification notes. Explanations can be inaccurate; the model has no surrounding conversation context.

## Earlier prototype

The original browser prototype is preserved in `dist/`, with its tests in `tests/`. Run `npm test` to verify it. See [prototype notes](docs/web-prototype.md). It is independent of the native app.

Build outputs, local logs, and demo editing files are ignored by Git.
