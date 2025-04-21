import SwiftUI

@main
struct Arizona_OnlineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootViewAO()
                .preferredColorScheme(.light)
        }
    }
}
