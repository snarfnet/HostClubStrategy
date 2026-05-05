import SwiftUI

enum AppTheme {
    static let bg = Color(red: 0.05, green: 0.02, blue: 0.10)
    static let bgMid = Color(red: 0.08, green: 0.03, blue: 0.15)
    static let card = Color(red: 0.10, green: 0.04, blue: 0.18)
    static let cardBorder = Color(red: 0.80, green: 0.20, blue: 0.50).opacity(0.4)

    static let pink = Color(red: 0.95, green: 0.25, blue: 0.55)
    static let pinkLight = Color(red: 1.0, green: 0.55, blue: 0.75)
    static let pinkGlow = Color(red: 0.95, green: 0.25, blue: 0.55).opacity(0.3)
    static let gold = Color(red: 1.0, green: 0.85, blue: 0.40)
    static let purple = Color(red: 0.55, green: 0.20, blue: 0.80)

    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.65)
    static let textPink = Color(red: 1.0, green: 0.65, blue: 0.80)

    static let danger = Color(red: 1.0, green: 0.25, blue: 0.25)
    static let safe = Color(red: 0.30, green: 0.90, blue: 0.60)
    static let warning = Color(red: 1.0, green: 0.75, blue: 0.20)
}
