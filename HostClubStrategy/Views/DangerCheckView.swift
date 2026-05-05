import SwiftUI

struct DangerCheckView: View {
    @State private var checkedItems: Set<UUID> = []

    private var dangerScore: Int {
        PainfulCustomerCheck.items.reduce(0) { total, item in
            guard checkedItems.contains(item.id) else { return total }
            switch item.severity {
            case .mild: return total + 1
            case .serious: return total + 3
            case .fatal: return total + 5
            }
        }
    }

    private var riskLevel: (title: String, subtitle: String, color: Color) {
        if dangerScore == 0 { return ("問題なし", "No Risk", AppTheme.safe) }
        if dangerScore <= 2 { return ("要注意", "Low Risk", AppTheme.gold) }
        if dangerScore <= 6 { return ("危険", "High Risk", AppTheme.warning) }
        return ("出禁候補", "Ban Risk", AppTheme.danger)
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    scoreCard

                    if dangerScore > 6 {
                        warningBanner
                    }

                    Text("やってしまったことにチェックを入れてください")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)

                    VStack(spacing: 14) {
                        SeveritySection(
                            title: "致命的",
                            titleEN: "Immediate Ban Risk",
                            color: AppTheme.danger,
                            icon: "xmark.octagon.fill",
                            items: PainfulCustomerCheck.items.filter { $0.severity == .fatal },
                            checkedItems: $checkedItems
                        )
                        SeveritySection(
                            title: "深刻",
                            titleEN: "Relationship Damage",
                            color: AppTheme.warning,
                            icon: "exclamationmark.triangle.fill",
                            items: PainfulCustomerCheck.items.filter { $0.severity == .serious },
                            checkedItems: $checkedItems
                        )
                        SeveritySection(
                            title: "注意",
                            titleEN: "Cooling Factor",
                            color: AppTheme.gold,
                            icon: "exclamationmark.circle.fill",
                            items: PainfulCustomerCheck.items.filter { $0.severity == .mild },
                            checkedItems: $checkedItems
                        )
                    }

                    if !checkedItems.isEmpty {
                        Button {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.86)) {
                                checkedItems.removeAll()
                            }
                        } label: {
                            Label("リセット", systemImage: "arrow.counterclockwise")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 10)
                                .background(Capsule().fill(AppTheme.card))
                                .overlay(Capsule().stroke(AppTheme.cardBorder, lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }

                    goldenRulesCard
                }
                .padding(.horizontal, 18)
                .padding(.top, 32)
                .padding(.bottom, 150)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("痛客チェッカー")
                .font(.system(size: 30, weight: .black))
                .foregroundStyle(AppTheme.titleGradient)
                .shadow(color: AppTheme.pinkGlow, radius: 12)
            Text("Painful Customer Checker")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
        }
    }

    private var scoreCard: some View {
        VStack(spacing: 10) {
            Image(systemName: "shield.lefthalf.filled")
                .font(.system(size: 30, weight: .semibold))
                .foregroundColor(riskLevel.color)
                .shadow(color: riskLevel.color.opacity(0.5), radius: 12)
            Text(riskLevel.title)
                .font(.system(size: 31, weight: .black))
                .foregroundColor(riskLevel.color)
            Text(riskLevel.subtitle)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(riskLevel.color.opacity(0.82))
            if dangerScore > 0 {
                Text("危険度スコア: \(dangerScore)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(22)
        .luxuryPanel(cornerRadius: 14, borderColor: riskLevel.color.opacity(0.52), glowColor: riskLevel.color.opacity(0.18), fill: riskLevel.color.opacity(0.10))
    }

    private var warningBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.octagon.fill")
                .foregroundColor(AppTheme.danger)
                .font(.system(size: 22))
            VStack(alignment: .leading, spacing: 4) {
                Text("出禁リスクが高いです")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(AppTheme.danger)
                Text("今すぐ行動を止めて、連絡頻度と来店ペースを落としましょう。")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 12).fill(AppTheme.danger.opacity(0.11)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.danger.opacity(0.42), lineWidth: 1))
    }

    private var goldenRulesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("痛客にならない5つのルール", systemImage: "crown.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(AppTheme.gold)

            ForEach(goldenRules, id: \.0) { rule, description in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "sparkle")
                        .foregroundColor(AppTheme.gold)
                        .font(.system(size: 10))
                        .padding(.top, 4)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(rule)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                        Text(description)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                            .lineSpacing(3)
                    }
                }
            }
        }
        .padding(16)
        .luxuryPanel(cornerRadius: 14, borderColor: AppTheme.gold.opacity(0.45), glowColor: AppTheme.gold.opacity(0.12))
    }

    private let goldenRules: [(String, String)] = [
        ("来店頻度は生活を崩さない範囲で", "詰めすぎるより、続けられるリズムのほうが印象は安定します。"),
        ("LINEは短く、余韻を残す", "毎日の長文より、軽く返せる一言のほうが負担になりません。"),
        ("お金の話で愛情を試さない", "使った額を武器にすると、一気に信頼が下がります。"),
        ("他のお客様の悪口は絶対NG", "品のある距離感は、店側からの信頼にもつながります。"),
        ("自分の生活を大切にする", "彼だけに集中しすぎないことが、結果的に一番強い魅力です。")
    ]
}

struct SeveritySection: View {
    let title: String
    let titleEN: String
    let color: Color
    let icon: String
    let items: [PainfulCustomerCheck.Item]
    @Binding var checkedItems: Set<UUID>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 15))
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(color)
                    Text(titleEN)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(color.opacity(0.72))
                }
            }

            ForEach(items) { item in
                DangerItemRow(item: item, color: color, isChecked: checkedItems.contains(item.id)) {
                    withAnimation(.spring(response: 0.22, dampingFraction: 0.86)) {
                        if checkedItems.contains(item.id) {
                            checkedItems.remove(item.id)
                        } else {
                            checkedItems.insert(item.id)
                        }
                    }
                }
            }
        }
        .padding(14)
        .luxuryPanel(cornerRadius: 12, borderColor: color.opacity(0.42), glowColor: color.opacity(0.10))
    }
}

struct DangerItemRow: View {
    let item: PainfulCustomerCheck.Item
    let color: Color
    let isChecked: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? color : AppTheme.textSecondary)
                    .font(.system(size: 18, weight: .semibold))

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.behavior)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(isChecked ? color : AppTheme.textPrimary)
                    if isChecked {
                        Text(item.risk)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(color.opacity(0.9))
                            .lineSpacing(2)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 5)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
