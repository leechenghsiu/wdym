import AppKit

@main @MainActor struct PanelToggleTests {
    static func main() {
        let app = NSApplication.shared
        app.setActivationPolicy(.accessory)
        let panel = QuestionPanel(contentRect: NSRect(x: 100, y: 100, width: 200, height: 100), styleMask: [.titled], backing: .buffered, defer: false)
        panel.isReleasedWhenClosed = false
        app.activate(ignoringOtherApps: true)
        panel.makeKeyAndOrderFront(nil)
        // The menu-bar click moves key focus before its mouseDown toggles the panel.
        panel.resignKey()
        if panel.isVisible { panel.orderOut(nil) } else { panel.makeKeyAndOrderFront(nil) }
        guard !panel.isVisible else { print("FAIL: second menu click reopened the panel after focus loss"); exit(1) }
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.05))
        panel.makeKeyAndOrderFront(nil)
        panel.resignKey()
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.05))
        guard !panel.isVisible else { print("FAIL: ordinary focus loss did not hide the panel"); exit(1) }
        print("PASS: menu click closes after focus loss; ordinary blur still hides")
        panel.orderOut(nil)
    }
}
