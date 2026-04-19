import AppKit

@MainActor
final class MousecopOverlay {
    private let window: NSWindow

    init() {
        window = NSWindow(
            contentRect: NSScreen.main!.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.level = .screenSaver
        window.alphaValue = 0.5
        window.ignoresMouseEvents = true
        window.backgroundColor = .red
    }

    func show() {
        window.orderFrontRegardless()
    }

    func hide() {
        window.orderOut(nil)
    }
}
