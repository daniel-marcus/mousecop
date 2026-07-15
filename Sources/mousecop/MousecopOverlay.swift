import AppKit

@MainActor
final class MousecopOverlay {
    private let window: NSWindow
    private let counterLabel: NSTextField
    private let screenFrame: NSRect

    init() {
        screenFrame = NSScreen.main!.frame
        window = NSWindow(
            contentRect: screenFrame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.level = .floating
        window.alphaValue = 0.5
        window.ignoresMouseEvents = true
        window.backgroundColor = .red

        counterLabel = NSTextField(labelWithString: "0")
        counterLabel.font = .systemFont(ofSize: 180, weight: .bold)
        counterLabel.textColor = .white
        counterLabel.alphaValue = 1
        counterLabel.autoresizingMask = [.minXMargin, .minYMargin]
        window.contentView?.addSubview(counterLabel)
        layoutCounterLabel()
    }

    private func layoutCounterLabel() {
        counterLabel.sizeToFit()
        counterLabel.frame.origin = NSPoint(
            x: screenFrame.width - counterLabel.frame.width - 20,
            y: screenFrame.height - counterLabel.frame.height - 20
        )
    }

    func show(count: Int) {
        updateCount(count)
        window.orderFrontRegardless()
    }

    func hide() {
        window.orderOut(nil)
    }

    func updateCount(_ count: Int) {
        counterLabel.stringValue = "\(count)"
        layoutCounterLabel()
    }
}
