import AppKit
import Observation

@MainActor
@Observable
final class MousecopMonitor {
    var monitoredBundleIDs: Set<String> = Set(UserDefaults.standard.stringArray(forKey: "monitoredBundleIDs") ?? []) {
        didSet { UserDefaults.standard.set(Array(monitoredBundleIDs), forKey: "monitoredBundleIDs") }
    }

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
        guard let frontmost = NSWorkspace.shared.frontmostApplication?.bundleIdentifier,
              monitoredBundleIDs.contains(frontmost) else { return }
        hideTimer?.invalidate()
        hideTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            MainActor.assumeIsolated { self?.overlay.hide() }
        }
        overlay.show()
    }

    func toggleMonitored(_ bundleID: String) {
        monitoredBundleIDs.formSymmetricDifference([bundleID])
    }
}
