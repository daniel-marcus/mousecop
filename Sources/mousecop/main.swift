import SwiftUI

struct MousecopApp: App {
    @State private var monitor = MousecopMonitor()

    var body: some Scene {
        MenuBarExtra("🐭") {
            Button(monitor.enabled ? "Disable Mousecop" : "Enable Mousecop") {
                monitor.toggle()
            }
            Divider()
            Button("Quit", role: .destructive) {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}

MousecopApp.main()
