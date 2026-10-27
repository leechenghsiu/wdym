import AppKit
import CoreText

let folder = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

func render(_ pixels: Int) -> Data {
    let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: pixels, pixelsHigh: pixels,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    let context = NSGraphicsContext(bitmapImageRep: bitmap)!
    NSGraphicsContext.current = context
    context.cgContext.scaleBy(x: CGFloat(pixels)/1024, y: CGFloat(pixels)/1024)
    let shape = NSBezierPath(roundedRect: NSRect(x: 84, y: 84, width: 856, height: 856), xRadius: 190, yRadius: 190)
    NSGraphicsContext.saveGraphicsState()
    let shadow = NSShadow(); shadow.shadowColor = NSColor.black.withAlphaComponent(0.18)
    shadow.shadowBlurRadius = 28; shadow.shadowOffset = NSSize(width: 0, height: -12); shadow.set()
    NSColor(calibratedRed: 0.97, green: 0.965, blue: 0.945, alpha: 1).setFill(); shape.fill()
    NSGraphicsContext.restoreGraphicsState()
    NSGradient(starting: NSColor(calibratedRed: 1, green: 0.997, blue: 0.98, alpha: 1),
               ending: NSColor(calibratedRed: 0.93, green: 0.93, blue: 0.89, alpha: 1))!.draw(in: shape, angle: -90)
    NSColor.white.withAlphaComponent(0.75).setStroke(); shape.lineWidth = 3; shape.stroke()
    let font = NSFont(name: "Baskerville-Italic", size: 400)!
    func row(_ string: String) -> CGPath {
        let attributed = NSAttributedString(string: string, attributes: [.font: font, .kern: -13])
        let line = CTLineCreateWithAttributedString(attributed)
        let path = CGMutablePath()
        for run in CTLineGetGlyphRuns(line) as! [CTRun] {
            let count = CTRunGetGlyphCount(run)
            var glyphs = [CGGlyph](repeating: 0, count: count)
            var positions = [CGPoint](repeating: .zero, count: count)
            CTRunGetGlyphs(run, CFRange(location: 0, length: count), &glyphs)
            CTRunGetPositions(run, CFRange(location: 0, length: count), &positions)
            let runFont = (CTRunGetAttributes(run) as NSDictionary)[kCTFontAttributeName] as! CTFont
            for index in 0..<count {
                if let glyph = CTFontCreatePathForGlyph(runFont, glyphs[index], nil) {
                    path.addPath(glyph, transform: CGAffineTransform(translationX: positions[index].x, y: positions[index].y))
                }
            }
        }
        return path
    }
    let top = row("wd"), bottom = row("ym")
    let combined = CGMutablePath()
    let topBounds = top.boundingBoxOfPath, bottomBounds = bottom.boundingBoxOfPath
    combined.addPath(bottom, transform: CGAffineTransform(translationX: -bottomBounds.midX, y: 0))
    combined.addPath(top, transform: CGAffineTransform(translationX: -topBounds.midX,
        y: bottomBounds.maxY + 28 - topBounds.minY))
    let bounds = combined.boundingBoxOfPath
    let scale = 600 / max(bounds.width, bounds.height)
    let transform = CGAffineTransform(a: scale, b: 0, c: 0, d: scale,
        tx: 512 - bounds.midX * scale, ty: 512 - bounds.midY * scale)
    context.cgContext.concatenate(transform)
    context.cgContext.addPath(combined)
    context.cgContext.setFillColor(NSColor(calibratedRed: 0.16, green: 0.18, blue: 0.15, alpha: 1).cgColor)
    context.cgContext.fillPath()
    NSGraphicsContext.restoreGraphicsState()
    return bitmap.representation(using: .png, properties: [:])!
}
for size in [16, 32, 128, 256, 512] {
    try render(size).write(to: folder.appendingPathComponent("icon_\(size)x\(size).png"))
    try render(size*2).write(to: folder.appendingPathComponent("icon_\(size)x\(size)@2x.png"))
}
print("Rendered macOS icon at all required resolutions")
