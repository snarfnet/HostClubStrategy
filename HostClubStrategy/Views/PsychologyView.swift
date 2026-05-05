import SwiftUI

struct PsychologyView: View {
    @State private var selectedTactic: PsychologyTactic? = nil

    var body: some View {
        ZStack {
            LinearGradient(colors: [AppTheme.bg, AppTheme.bgMid],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Text("心理学テクニック")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(AppTheme.textPrimary)
                        Text("Psychology Tactics Library")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(.top, 16)

                    // Intro card
                    VStack(alignment: .leading, spacing: 8) {
                        Label("書籍ベースの恋愛心理学", systemImage: "book.fill")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(AppTheme.gold)
                        Text("300冊以上の恋愛・心理学書籍から厳選したテクニック集。ホストクラブという特殊な環境に最適化しています。")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary)
                            .lineSpacing(4)
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppTheme.gold.opacity(0.08))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.gold.opacity(0.3), lineWidth: 1))
                    )
                    .padding(.horizontal, 16)

                    // Attachment styles section
                    VStack(alignment: .leading, spacing: 12) {
                        Label("愛着スタイル別 攻略法", systemImage: "brain.head.profile")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(AppTheme.purple)
                            .padding(.horizontal, 16)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(AttachmentStyle.allCases) { style in
                                    AttachmentStyleCard(style: style)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }

                    // All tactics
                    VStack(alignment: .leading, spacing: 12) {
                        Label("全テクニック一覧", systemImage: "list.star")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(AppTheme.pink)
                            .padding(.horizontal, 16)

                        ForEach(PsychologyEngine.allTactics) { tactic in
                            TacticCard(tactic: tactic, isExpanded: selectedTactic?.id == tactic.id) {
                                withAnimation(.spring(response: 0.3)) {
                                    if selectedTactic?.id == tactic.id {
                                        selectedTactic = nil
                                    } else {
                                        selectedTactic = tactic
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }

                    // Bad boy psychology section (from books)
                    VStack(alignment: .leading, spacing: 10) {
                        Label("なぜ「悪い男」が選ばれるのか", systemImage: "flame.fill")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(AppTheme.danger)
                            .padding(.horizontal, 16)

                        VStack(alignment: .leading, spacing: 12) {
                            BadBoyInsightRow(
                                title: "自信（Confidence）",
                                body: "結果を恐れない姿勢。どんな状況でも「断られてもいい」という余裕が、逆に魅力的に映る。ホストが複数の客と接しても揺れないのはこのため。"
                            )
                            Divider().background(AppTheme.cardBorder)
                            BadBoyInsightRow(
                                title: "過度な依存をしない",
                                body: "相手に必要以上に執着しない人間は希少性が高い。恋愛書籍では一貫して「追いかけすぎる側が不利」と語られる。"
                            )
                            Divider().background(AppTheme.cardBorder)
                            BadBoyInsightRow(
                                title: "ミステリアスさ（Not Fully Available）",
                                body: "すべてをさらけ出さない。「まだ知らない面がある」という感覚が相手を引きつけ続ける。"
                            )
                            Divider().background(AppTheme.cardBorder)
                            BadBoyInsightRow(
                                title: "応用：あなたが使う方法",
                                body: "彼に対して同じ原理を使う。依存を見せず、自分の世界を持ち、「この人を理解したい」と思わせること。"
                            )
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppTheme.card)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppTheme.cardBorder, lineWidth: 1))
                        )
                        .padding(.horizontal, 16)
                    }

                    Spacer(minLength: 40)
                }
            }
        }
    }
}

struct AttachmentStyleCard: View {
    let style: AttachmentStyle

    var color: Color {
        switch style {
        case .secure: return AppTheme.safe
        case .anxious: return AppTheme.pink
        case .avoidant: return AppTheme.purple
        case .fearful: return AppTheme.gold
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(style.label)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(color)
            Text(style.description)
                .font(.system(size: 10))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(3)
                .lineLimit(4)
            Divider().background(color.opacity(0.3))
            Text(style.strategy)
                .font(.system(size: 10))
                .foregroundColor(AppTheme.textPrimary)
                .lineSpacing(3)
                .lineLimit(5)
            Text("⚠ \(style.warningSign)")
                .font(.system(size: 10))
                .foregroundColor(AppTheme.warning)
                .lineLimit(2)
        }
        .padding(14)
        .frame(width: 220)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.card)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.4), lineWidth: 1))
        )
    }
}

struct TacticCard: View {
    let tactic: PsychologyTactic
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(tactic.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                        Text(tactic.nameEN)
                            .font(.system(size: 10))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    Spacer()
                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { i in
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundColor(i < tactic.effectiveness ? AppTheme.gold : AppTheme.textSecondary.opacity(0.3))
                        }
                    }
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                        .padding(.leading, 6)
                }

                if isExpanded {
                    VStack(alignment: .leading, spacing: 10) {
                        InfoRow(icon: "lightbulb.fill", color: AppTheme.gold, label: "理論", text: tactic.theory)
                        InfoRow(icon: "checkmark.circle.fill", color: AppTheme.safe, label: "やり方", text: tactic.howTo)
                        InfoRow(icon: "exclamationmark.triangle.fill", color: AppTheme.danger, label: "注意点", text: tactic.caution)
                    }
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(AppTheme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isExpanded ? AppTheme.pink.opacity(0.5) : AppTheme.cardBorder, lineWidth: 1)
                    )
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
        VStack(alignment: .leading, spacing: 4) {
            Label(label, systemImage: icon)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(color)
            Text(text)
                .font(.system(size: 11))
                .foregroundColor(AppTheme.textPrimary)
                .lineSpacing(3)
        }
    }
}

struct BadBoyInsightRow: View {
    let title: String
    let body: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(AppTheme.danger)
            Text(body)
                .font(.system(size: 11))
                .foregroundColor(AppTheme.textPrimary)
                .lineSpacing(3)
        }
    }
}
