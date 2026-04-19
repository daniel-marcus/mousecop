import AppKit
import Observation

@MainActor
@Observable
final class MousecopMonitor {
    var enabled = true

    private let overlay = MousecopOverlay()
    private var eventMonitor: Any?
    private var hideTimer: Timer?

    init() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.mouseMoved, .leftMouseDown, .rightMouseDown, .leftMouseDragged, .rightMouseDragged]
        ) { [weak self] _ in
            self?.handleMouseEvent()
        }
    }

    private func handleMouseEvent() {
        guard enabled else { return }
        hideTimer?.invalidate()
        hideTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            MainActor.assumeIsolated { self?.overlay.hide() }
        }
        overlay.show()
    }

    func toggle() {
        enabled.toggle()
        if !enabled { overlay.hide() }
    }
}
