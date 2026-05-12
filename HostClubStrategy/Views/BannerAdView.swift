import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = "ca-app-pub-9404799280370656/3339832011"
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        guard uiView.rootViewController == nil else { return }
        if let windowScene = uiView.window?.windowScene,
           let rootVC = windowScene.keyWindow?.rootViewController {
            uiView.rootViewController = rootVC
            uiView.load(Request())
        }
    }
}
