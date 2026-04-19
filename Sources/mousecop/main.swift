import AppKit
import SwiftUI

struct MousecopApp: App {
    @State private var monitor = MousecopMonitor()
    @State private var runningApps: [NSRunningApplication] = []

    var body: some Scene {
        MenuBarExtra("🐭") {
            Section("Patrol:") {
                ForEach(runningApps, id: \.bundleIdentifier) { app in
                    if let id = app.bundleIdentifier {
                        Toggle(isOn: Binding(
                            get: { monitor.monitoredBundleIDs.contains(id) },
                            set: { _ in monitor.toggleMonitored(id) }
                        )) {
                            Label {
                                Text(app.localizedName ?? id)
                            } icon: {
                                icon(app.icon)
                            }
                        }
                    }
                }
            }
            .onAppear { updateRunningApps() }
            .onReceive(NotificationCenter.default.publisher(for: NSMenu.didBeginTrackingNotification)) { _ in
                updateRunningApps()
            }

            Divider()

            Button("Quit", role: .destructive) {
                NSApplication.shared.terminate(nil)
            }
        }
    }

    private func updateRunningApps() {
        runningApps = NSWorkspace.shared.runningApplications
            .filter { $0.activationPolicy == .regular && $0.bundleIdentifier != Bundle.main.bundleIdentifier }
            .sorted { ($0.localizedName ?? "") < ($1.localizedName ?? "") }
    }

    private func icon(_ nsImage: NSImage?) -> Image {
        if let img = nsImage { Image(nsImage: img) } else { Image(systemName: "app.dashed") }
    }
}

MousecopApp.main()
