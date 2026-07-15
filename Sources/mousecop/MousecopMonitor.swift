import AppKit
import Observation

@MainActor
@Observable
final class MousecopMonitor {
    var monitoredBundleIDs: Set<String> = Set(UserDefaults.standard.stringArray(forKey: "monitoredBundleIDs") ?? []) {
        didSet { UserDefaults.standard.set(Array(monitoredBundleIDs), forKey: "monitoredBundleIDs") }
    }

    private(set) var touchCount = 0

    var touchesPerMinute: Double {
        let minutes = Date().timeIntervalSince(trackingStart) / 60
        guard minutes > 0 else { return 0 }
        return Double(touchCount) / minutes
    }

    private let overlay = MousecopOverlay()
    private var eventMonitor: Any?
    private var hideTimer: Timer?
    private var trackingStart = Date()

    init() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.mouseMoved, .leftMouseDown, .rightMouseDown, .leftMouseDragged, .rightMouseDragged]
        ) { [weak self] _ in
            self?.handleMouseEvent()
        }
    }

    private func handleMouseEvent() {
        guard let frontmost = NSWorkspace.shared.frontmostApplication?.bundleIdentifier,
              monitoredBundleIDs.contains(frontmost) else { return }
        let isNewTouch = hideTimer == nil
        hideTimer?.invalidate()
        hideTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.hideTimer = nil
                self?.overlay.hide()
            }
        }
        if isNewTouch {
            touchCount += 1
            overlay.show(count: touchCount)
        }
    }

    func toggleMonitored(_ bundleID: String) {
        monitoredBundleIDs.formSymmetricDifference([bundleID])
    }

    func resetCounter() {
        touchCount = 0
        trackingStart = Date()
        overlay.updateCount(0)
    }
}
