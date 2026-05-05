import SwiftUI

enum AppTheme {
    static let bg = Color(red: 0.025, green: 0.010, blue: 0.055)
    static let bgMid = Color(red: 0.070, green: 0.025, blue: 0.120)
    static let bgDeep = Color(red: 0.010, green: 0.006, blue: 0.025)
    static let card = Color(red: 0.095, green: 0.045, blue: 0.145).opacity(0.86)
    static let cardElevated = Color(red: 0.140, green: 0.050, blue: 0.190).opacity(0.92)
    static let cardBorder = Color(red: 1.000, green: 0.285, blue: 0.650).opacity(0.42)

    static let pink = Color(red: 1.000, green: 0.250, blue: 0.640)
    static let pinkLight = Color(red: 1.000, green: 0.700, blue: 0.900)
    static let pinkGlow = Color(red: 1.000, green: 0.180, blue: 0.650).opacity(0.38)
    static let gold = Color(red: 1.000, green: 0.820, blue: 0.430)
    static let purple = Color(red: 0.620, green: 0.290, blue: 0.940)
    static let violet = Color(red: 0.360, green: 0.160, blue: 0.600)
    static let cyan = Color(red: 0.360, green: 0.900, blue: 0.980)

    static let textPrimary = Color(red: 1.000, green: 0.940, blue: 1.000)
    static let textSecondary = Color(red: 0.700, green: 0.610, blue: 0.780)
    static let textPink = Color(red: 1.000, green: 0.650, blue: 0.850)

    static let danger = Color(red: 1.000, green: 0.230, blue: 0.360)
    static let safe = Color(red: 0.300, green: 0.900, blue: 0.660)
    static let warning = Color(red: 1.000, green: 0.690, blue: 0.240)

    static let titleGradient = LinearGradient(
        colors: [pinkLight, textPrimary, pink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let jewelGradient = LinearGradient(
        colors: [pink, purple, Color(red: 0.300, green: 0.120, blue: 0.520)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct AppBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.bgDeep, AppTheme.bg, AppTheme.bgMid, AppTheme.bgDeep],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            RadialGradient(
                colors: [AppTheme.pink.opacity(0.24), .clear],
                center: .topTrailing,
                startRadius: 20,
                endRadius: 280
            )
            RadialGradient(
                colors: [AppTheme.purple.opacity(0.28), .clear],
                center: .bottomLeading,
                startRadius: 40,
                endRadius: 320
            )
            LuxuryStarsBackground()
        }
        .ignoresSafeArea()
    }
}

struct LuxuryStarsBackground: View {
    private let stars: [(x: CGFloat, y: CGFloat, size: CGFloat, opacity: Double)] = [
        (0.08, 0.07, 2.0, 0.85), (0.18, 0.15, 1.0, 0.55), (0.32, 0.05, 1.5, 0.65),
        (0.55, 0.12, 1.0, 0.50), (0.78, 0.08, 2.4, 0.80), (0.92, 0.18, 1.2, 0.62),
        (0.12, 0.34, 1.3, 0.52), (0.44, 0.28, 2.0, 0.72), (0.86, 0.37, 1.4, 0.58),
        (0.24, 0.58, 1.1, 0.50), (0.64, 0.52, 1.7, 0.64), (0.94, 0.62, 1.0, 0.56),
        (0.10, 0.78, 2.1, 0.80), (0.38, 0.86, 1.1, 0.55), (0.72, 0.82, 1.8, 0.70),
        (0.88, 0.92, 1.2, 0.55)
    ]

    var body: some View {
        GeometryReader { geo in
            ForEach(stars.indices, id: \.self) { index in
                let star = stars[index]
                SparkleShape()
                    .fill(AppTheme.pinkLight.opacity(star.opacity))
                    .frame(width: star.size * 8, height: star.size * 8)
                    .position(x: geo.size.width * star.x, y: geo.size.height * star.y)
                    .shadow(color: AppTheme.pinkGlow, radius: 8)
            }
        }
        .allowsHitTesting(false)
    }
}

struct SparkleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: CGPoint(x: center.x, y: rect.minY))
        path.addLine(to: CGPoint(x: center.x + rect.width * 0.10, y: center.y - rect.height * 0.10))
        path.addLine(to: CGPoint(x: rect.maxX, y: center.y))
        path.addLine(to: CGPoint(x: center.x + rect.width * 0.10, y: center.y + rect.height * 0.10))
        path.addLine(to: CGPoint(x: center.x, y: rect.maxY))
        path.addLine(to: CGPoint(x: center.x - rect.width * 0.10, y: center.y + rect.height * 0.10))
        path.addLine(to: CGPoint(x: rect.minX, y: center.y))
        path.addLine(to: CGPoint(x: center.x - rect.width * 0.10, y: center.y - rect.height * 0.10))
        path.closeSubpath()
        return path
    }
}

struct LuxuryPanel: ViewModifier {
    var cornerRadius: CGFloat = 16
    var borderColor: Color = AppTheme.cardBorder
    var glowColor: Color = AppTheme.pinkGlow
    var fill: Color = AppTheme.card

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fill)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [borderColor.opacity(0.95), AppTheme.pinkLight.opacity(0.28), borderColor.opacity(0.52)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: glowColor, radius: 16, x: 0, y: 0)
                    .shadow(color: Color.black.opacity(0.35), radius: 14, x: 0, y: 10)
            )
    }
}

extension View {
    func luxuryPanel(
        cornerRadius: CGFloat = 16,
        borderColor: Color = AppTheme.cardBorder,
        glowColor: Color = AppTheme.pinkGlow,
        fill: Color = AppTheme.card
    ) -> some View {
        modifier(LuxuryPanel(cornerRadius: cornerRadius, borderColor: borderColor, glowColor: glowColor, fill: fill))
    }
}
