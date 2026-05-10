import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct HostClubStrategyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .task {
                    try? await Task.sleep(for: .seconds(1))
                    ATTrackingManager.requestTrackingAuthorization { _ in
                        DispatchQueue.main.async {
                            MobileAds.shared.start(completionHandler: nil)
                        }
                    }
                }
        }
    }
}
