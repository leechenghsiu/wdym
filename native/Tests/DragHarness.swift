import AppKit

final class DragSource: NSView, NSDraggingSource {
    override func draw(_ rect: NSRect) {
        ("race condition" as NSString).draw(at: NSPoint(x: 22, y: 42), withAttributes: [.font:NSFont.systemFont(ofSize: 19),.foregroundColor:NSColor.labelColor])
    }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }
    override func mouseDown(with event: NSEvent) {
        print("source down / begin drag"); fflush(stdout)
        let board = NSPasteboardItem(); board.setString("race condition", forType: .string)
        let item = NSDraggingItem(pasteboardWriter: board)
        let image = NSImage(size: NSSize(width: 180, height: 38))
        image.lockFocus()
        ("race condition" as NSString).draw(at: NSPoint(x: 5, y: 8), withAttributes: [.font:NSFont.systemFont(ofSize: 19),.foregroundColor:NSColor.labelColor])
        image.unlockFocus()
        item.setDraggingFrame(NSRect(x: 15, y: 35, width: 180, height: 38), contents: image)
        beginDraggingSession(with: [item], event: event, source: self)
    }
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation { .copy }
}

@main @MainActor struct DragHarness {
    static func main() {
        let app = NSApplication.shared
        app.setActivationPolicy(.regular)
        let window = NSWindow(contentRect:NSRect(x:200,y:250,width:520,height:230),styleMask:[.titled,.closable],backing:.buffered,defer:false)
        window.title = "wdym native drag test"
        let root = NSView(frame:NSRect(x:0,y:0,width:520,height:230))
        let source = DragSource(frame:NSRect(x:20,y:75,width:220,height:110))
        source.wantsLayer = true; source.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
        let destination = DropSurface(frame:NSRect(x:280,y:75,width:220,height:110))
        destination.wantsLayer = true; destination.layer?.backgroundColor = NSColor.systemBlue.withAlphaComponent(0.15).cgColor
        let label = NSTextField(labelWithString:"Drag left → right")
        label.frame = NSRect(x:25,y:22,width:470,height:26)
        let targetLabel = NSTextField(labelWithString:"DROP HERE")
        targetLabel.frame = NSRect(x:330,y:120,width:130,height:25)
        destination.receive = { text in print("destination received"); fflush(stdout); label.stringValue = text == "race condition" ? "PASS: native text drop received" : "FAIL: unexpected text" }
        destination.hover = { active in print("hover", active); fflush(stdout); destination.layer?.borderWidth = active ? 2 : 0 }
        root.addSubview(source); root.addSubview(destination); root.addSubview(targetLabel); root.addSubview(label)
        window.contentView = root; window.center(); window.makeKeyAndOrderFront(nil); app.activate(ignoringOtherApps:true)
        withExtendedLifetime(window) { app.run() }
    }
}
