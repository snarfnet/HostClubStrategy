import SwiftUI

struct DangerCheckView: View {
    @State private var checkedItems: Set<UUID> = []

    var dangerScore: Int {
        var score = 0
        for item in PainfulCustomerCheck.items {
            if checkedItems.contains(item.id) {
                switch item.severity {
                case .mild: score += 1
                case .serious: score += 3
                case .fatal: score += 5
                }
            }
        }
        return score
    }

    var riskLevel: (String, String, Color) {
        if dangerScore == 0 { return ("問題なし", "No Risk", AppTheme.safe) }
        if dangerScore <= 2 { return ("要注意", "Low Risk", AppTheme.gold) }
        if dangerScore <= 6 { return ("危険", "High Risk", AppTheme.warning) }
        return ("出禁候補", "Ban Risk!", AppTheme.danger)
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [AppTheme.bg, AppTheme.bgMid],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Text("痛客チェッカー")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(AppTheme.textPrimary)
                        Text("Painful Customer Checker")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(.top, 16)

                    // Score display
                    VStack(spacing: 10) {
                        Text(riskLevel.0)
                            .font(.system(size: 32, weight: .black))
                            .foregroundColor(riskLevel.2)
                            .shadow(color: riskLevel.2.opacity(0.5), radius: 8)
                        Text(riskLevel.1)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(riskLevel.2.opacity(0.8))
                        if dangerScore > 0 {
                            Text("危険度スコア: \(dangerScore)")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(riskLevel.2.opacity(0.1))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(riskLevel.2.opacity(0.4), lineWidth: 1))
                    )
                    .padding(.horizontal, 16)

                    // Warning banner for high risk
                    if dangerScore > 6 {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.octagon.fill")
                                .foregroundColor(AppTheme.danger)
                                .font(.system(size: 20))
                            VStack(alignment: .leading, spacing: 3) {
                                Text("出禁リスクが非常に高いです")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(AppTheme.danger)
                                Text("今すぐ行動を改めないと、最悪の結果になります。")
                                    .font(.system(size: 11))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppTheme.danger.opacity(0.1))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.danger.opacity(0.4), lineWidth: 1))
                        )
                        .padding(.horizontal, 16)
                    }

                    // Instructions
                    Text("やってしまったことにチェックを入れてください")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    // Checklist by severity
                    VStack(spacing: 16) {
                        SeveritySection(
                            title: "致命的（即出禁レベル）",
                            titleEN: "Fatal — Immediate Ban Risk",
                            color: AppTheme.danger,
                            icon: "xmark.octagon.fill",
                            items: PainfulCustomerCheck.items.filter { $0.severity == .fatal },
                            checkedItems: $checkedItems
                        )
                        SeveritySection(
                            title: "深刻（関係が壊れる）",
                            titleEN: "Serious — Relationship Damage",
                            color: AppTheme.warning,
                            icon: "exclamationmark.triangle.fill",
                            items: PainfulCustomerCheck.items.filter { $0.severity == .serious },
                            checkedItems: $checkedItems
                        )
                        SeveritySection(
                            title: "注意（冷める原因）",
                            titleEN: "Mild — Cooling Factor",
                            color: AppTheme.gold,
                            icon: "exclamationmark.circle.fill",
                            items: PainfulCustomerCheck.items.filter { $0.severity == .mild },
                            checkedItems: $checkedItems
                        )
                    }
                    .padding(.horizontal, 16)

                    // Reset button
                    if !checkedItems.isEmpty {
                        Button {
                            withAnimation { checkedItems.removeAll() }
                        } label: {
                            Label("リセット", systemImage: "arrow.counterclockwise")
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textSecondary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .fill(AppTheme.card)
                                        .overlay(Capsule().stroke(AppTheme.cardBorder, lineWidth: 1))
                                )
                        }
                    }

                    // Golden rules
                    VStack(alignment: .leading, spacing: 12) {
                        Label("痛客にならない黄金ルール", systemImage: "crown.fill")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(AppTheme.gold)

                        ForEach(goldenRules, id: \.0) { rule, desc in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "sparkle")
                                    .foregroundColor(AppTheme.gold)
                                    .font(.system(size: 10))
                                    .padding(.top, 3)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(rule)
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(AppTheme.textPrimary)
                                    Text(desc)
                                        .font(.system(size: 11))
                                        .foregroundColor(AppTheme.textSecondary)
                                        .lineSpacing(2)
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppTheme.card)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppTheme.gold.opacity(0.3), lineWidth: 1))
                    )
                    .padding(.horizontal, 16)

                    Spacer(minLength: 40)
                }
            }
        }
    }

    let goldenRules: [(String, String)] = [
        ("来店頻度は週1〜2回まで", "それ以上は「重い客」認定の始まり。希少性を保つことが最重要。"),
        ("LINEは1日1〜2通まで", "毎日大量送信は即ブロック候補。短く、面白く、余韻を残して終わる。"),
        ("お金の話を自分から出さない", "「いくら使ったか」を強調するのは品がない。黙って使うのが美学。"),
        ("他の客の悪口は絶対NG", "スタッフは全員繋がっている。一度言ったら必ず広まる。"),
        ("自分の生活を大切に", "ホストクラブがすべての女性は長続きしない。自分の仕事・友達・趣味を保つことが攻略の基本。"),
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
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 14))
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(color)
                    Text(titleEN)
                        .font(.system(size: 10))
                        .foregroundColor(color.opacity(0.7))
                }
            }

            ForEach(items) { item in
                DangerItemRow(item: item, color: color, isChecked: checkedItems.contains(item.id)) {
                    withAnimation(.spring(response: 0.2)) {
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
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.card)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.3), lineWidth: 1))
        )
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
                    .font(.system(size: 18))

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.behavior)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(isChecked ? color : AppTheme.textPrimary)
                    if isChecked {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 9))
                            Text(item.risk)
                                .font(.system(size: 10))
                        }
                        .foregroundColor(color)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}
