import SwiftUI

struct PsychologyView: View {
    @State private var selectedTactic: PsychologyTactic?

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    header
                    introCard
                    attachmentSection
                    tacticsSection
                    mindsetSection
                }
                .padding(.horizontal, 18)
                .padding(.top, 32)
                .padding(.bottom, 150)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("心理学テクニック")
                .font(.system(size: 30, weight: .black))
                .foregroundStyle(AppTheme.titleGradient)
                .shadow(color: AppTheme.pinkGlow, radius: 12)
            Text("Psychology Tactics Library")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
        }
    }

    private var introCard: some View {
        ZStack(alignment: .trailing) {
            VStack(alignment: .leading, spacing: 8) {
                Label("書籍ベースの恋愛心理学", systemImage: "book.closed.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.gold)
                Text("ホストクラブという特殊な距離感に合わせて、使いやすい心理テクだけを整理しました。")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(4)
                    .padding(.trailing, 78)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(AppTheme.titleGradient)
                .shadow(color: AppTheme.pinkGlow, radius: 16)
        }
        .padding(16)
        .luxuryPanel(cornerRadius: 14, borderColor: AppTheme.gold.opacity(0.45), glowColor: AppTheme.gold.opacity(0.12))
    }

    private var attachmentSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle(title: "愛着スタイル別 攻略法", subtitle: "Attachment Style Strategy", icon: "brain.head.profile")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(AttachmentStyle.allCases) { style in
                        AttachmentStyleCard(style: style)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private var tacticsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle(title: "全テクニック一覧", subtitle: "All Tactics", icon: "list.star")

            ForEach(PsychologyEngine.allTactics) { tactic in
                TacticCard(tactic: tactic, isExpanded: selectedTactic?.id == tactic.id) {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.84)) {
                        selectedTactic = selectedTactic?.id == tactic.id ? nil : tactic
                    }
                }
            }
        }
    }

    private var mindsetSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("選ばれる人の共通点", systemImage: "flame.fill")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(AppTheme.pinkLight)

            InsightRow(title: "余白を持つ", content: "会えない時間を全部不安で埋めない。彼以外の生活がある人は、自然に魅力が残ります。")
            Divider().background(AppTheme.cardBorder)
            InsightRow(title: "感情をぶつけず、印象を残す", content: "好きという圧より、今日楽しかったという軽い余韻のほうが次につながりやすいです。")
            Divider().background(AppTheme.cardBorder)
            InsightRow(title: "お客様としての品を守る", content: "支払い、連絡頻度、他のお客様への態度。ここが安定している人は、店側からも信頼されます。")
        }
        .padding(16)
        .luxuryPanel(cornerRadius: 14)
    }
}

struct AttachmentStyleCard: View {
    let style: AttachmentStyle

    private var color: Color {
        switch style {
        case .secure: return AppTheme.safe
        case .anxious: return AppTheme.pink
        case .avoidant: return AppTheme.purple
        case .fearful: return AppTheme.gold
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(color)
                Text(style.label)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(color)
            }

            Text(style.description)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
                .lineLimit(2)

            Text(style.strategy)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(3)
                .lineLimit(5)

            Text(style.warningSign)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(AppTheme.warning)
                .lineLimit(2)
        }
        .padding(14)
        .frame(width: 232, height: 190, alignment: .topLeading)
        .luxuryPanel(cornerRadius: 12, borderColor: color.opacity(0.48), glowColor: color.opacity(0.12))
    }
}

struct TacticCard: View {
    let tactic: PsychologyTactic
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 11) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.pink.opacity(0.16))
                            .frame(width: 42, height: 42)
                        Image(systemName: "sparkles")
                            .foregroundColor(AppTheme.pinkLight)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(tactic.name)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                        Text(tactic.nameEN)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                    }

                    Spacer()
                    RatingStars(value: tactic.effectiveness, size: 9)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(AppTheme.textSecondary)
                }

                if isExpanded {
                    VStack(alignment: .leading, spacing: 11) {
                        InfoRow(icon: "lightbulb.fill", color: AppTheme.gold, label: "理論", text: tactic.theory)
                        InfoRow(icon: "checkmark.circle.fill", color: AppTheme.safe, label: "やり方", text: tactic.howTo)
                        InfoRow(icon: "exclamationmark.triangle.fill", color: AppTheme.danger, label: "注意点", text: tactic.caution)
                    }
                    .padding(.top, 4)
                }
            }
            .padding(14)
            .luxuryPanel(
                cornerRadius: 12,
                borderColor: isExpanded ? AppTheme.pink : AppTheme.cardBorder,
                glowColor: isExpanded ? AppTheme.pinkGlow : .clear
            )
        }
        .buttonStyle(.plain)
    }
}

struct InfoRow: View {
    let icon: String
    let color: Color
    let label: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Label(label, systemImage: icon)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(color)
            Text(text)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)
                .lineSpacing(3)
        }
    }
}

struct InsightRow: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(AppTheme.pinkLight)
            Text(content)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(3)
        }
    }
}
