import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct HostClubStrategyApp: App {
    init() {
        MobileAds.shared.start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .task {
                    try? await Task.sleep(for: .seconds(1))
                    ATTrackingManager.requestTrackingAuthorization { _ in }
                }
        }
    }
}
