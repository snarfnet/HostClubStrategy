import SwiftUI

struct StrategyView: View {
    @Binding var input: StrategyInput
    @State private var attachmentStyle: AttachmentStyle = .secure
    @State private var showResult = false
    @State private var result: StrategyResult?

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    header

                    GoalBadge(goal: input.goal)

                    InputSection(title: "彼のタイプ（愛着スタイル）", titleEN: "His Attachment Style", icon: "heart.text.square.fill") {
                        VStack(spacing: 10) {
                            ForEach(AttachmentStyle.allCases) { style in
                                AttachmentStyleRow(style: style, isSelected: attachmentStyle == style) {
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.84)) {
                                        attachmentStyle = style
                                    }
                                }
                            }
                        }
                    }

                    InputSection(title: "今日の彼の態度", titleEN: "His Current Mood", icon: "sparkles") {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                            ForEach(HostMood.allCases) { mood in
                                MoodChip(mood: mood, isSelected: input.hostMood == mood) {
                                    input.hostMood = mood
                                }
                            }
                        }
                    }

                    InputSection(title: "これまでの使った金額", titleEN: "Total Spending", icon: "creditcard.fill") {
                        VStack(spacing: 8) {
                            ForEach(SpendingLevel.allCases) { level in
                                SelectRow(label: level.label, isSelected: input.spending == level) {
                                    input.spending = level
                                }
                            }
                        }
                    }

                    InputSection(title: "来店頻度", titleEN: "Visit Frequency", icon: "calendar") {
                        VStack(spacing: 8) {
                            ForEach(VisitFrequency.allCases) { frequency in
                                SelectRow(label: frequency.label, isSelected: input.frequency == frequency) {
                                    input.frequency = frequency
                                }
                            }
                        }
                    }

                    InputSection(title: "進展済みの項目", titleEN: "Milestones", icon: "checkmark.seal.fill") {
                        VStack(spacing: 12) {
                            ToggleRow(label: "LINE / SNSの連絡先をゲット済み", isOn: $input.hasLineSNS)
                            ToggleRow(label: "店外で会ったことがある", isOn: $input.hasPrivateMeet)
                            ToggleRow(label: "名前で呼んでくれる", isOn: $input.calledByName)
                            ToggleRow(label: "プレゼントをもらった", isOn: $input.receivedGift)
                            ToggleRow(label: "競合する他のお客様がいる", isOn: $input.otherCustomersExist)
                        }
                    }

                    Button {
                        result = PsychologyEngine.analyzeStrategy(input: input, attachmentStyle: attachmentStyle)
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                            showResult = true
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "sparkles")
                            Text("攻略を診断する")
                                .font(.system(size: 17, weight: .black))
                            Image(systemName: "sparkles")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppTheme.jewelGradient)
                                .shadow(color: AppTheme.pinkGlow, radius: 18)
                        )
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.pinkLight.opacity(0.65), lineWidth: 1))
                    }
                    .buttonStyle(.plain)

                    if showResult, let result {
                        StrategyResultView(result: result, input: input, attachmentStyle: attachmentStyle)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 32)
                .padding(.bottom, 150)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Text("状況を入力")
                .font(.system(size: 30, weight: .black))
                .foregroundStyle(AppTheme.titleGradient)
                .shadow(color: AppTheme.pinkGlow, radius: 12)
            Text("Analyze Your Situation")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
            Image(systemName: "sparkle")
                .foregroundColor(AppTheme.pinkLight)
                .shadow(color: AppTheme.pinkGlow, radius: 10)
        }
    }
}

struct GoalBadge: View {
    let goal: Goal

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: goal.icon)
            Text("目標：\(goal.title)")
                .font(.system(size: 14, weight: .bold))
            Spacer()
        }
        .foregroundColor(AppTheme.pinkLight)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .luxuryPanel(cornerRadius: 12, borderColor: AppTheme.pink, glowColor: AppTheme.pinkGlow, fill: AppTheme.pink.opacity(0.12))
    }
}

struct InputSection<Content: View>: View {
    let title: String
    let titleEN: String
    let icon: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            SectionTitle(title: title, subtitle: titleEN, icon: icon)
            content
        }
        .padding(15)
        .luxuryPanel(cornerRadius: 14)
    }
}

struct AttachmentStyleRow: View {
    let style: AttachmentStyle
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(isSelected ? AppTheme.jewelGradient : LinearGradient(colors: [AppTheme.bgMid], startPoint: .top, endPoint: .bottom))
                        .frame(width: 46, height: 46)
                    Image(systemName: isSelected ? "heart.fill" : "diamond.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isSelected ? .white : AppTheme.pinkLight)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(style.label)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(isSelected ? AppTheme.pinkLight : AppTheme.textPrimary)
                    Text(style.description)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isSelected ? AppTheme.pinkLight : AppTheme.textSecondary.opacity(0.65))
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? AppTheme.pink.opacity(0.15) : AppTheme.bgMid.opacity(0.72))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? AppTheme.pink.opacity(0.72) : AppTheme.cardBorder.opacity(0.35), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct MoodChip: View {
    let mood: HostMood
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 7) {
                Image(systemName: mood.icon)
                    .font(.system(size: 21, weight: .medium))
                    .foregroundColor(isSelected ? AppTheme.pinkLight : AppTheme.textSecondary)
                Text(mood.label)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(isSelected ? AppTheme.pinkLight : AppTheme.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity, minHeight: 72)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? AppTheme.pink.opacity(0.16) : AppTheme.bgMid.opacity(0.72))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? AppTheme.pink.opacity(0.75) : AppTheme.cardBorder.opacity(0.32), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct SelectRow: View {
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? AppTheme.pinkLight : AppTheme.textSecondary)
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(isSelected ? AppTheme.pinkLight : AppTheme.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(
                RoundedRectangle(cornerRadius: 9)
                    .fill(isSelected ? AppTheme.pink.opacity(0.13) : AppTheme.bgMid.opacity(0.72))
            )
        }
        .buttonStyle(.plain)
    }
}

struct ToggleRow: View {
    let label: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(AppTheme.pink)
                .labelsHidden()
        }
        .padding(.vertical, 2)
    }
}

struct StrategyResultView: View {
    let result: StrategyResult
    let input: StrategyInput
    let attachmentStyle: AttachmentStyle

    private var timingColor: Color {
        switch result.timing {
        case .goNow: return AppTheme.pink
        case .goodTiming: return AppTheme.gold
        case .waitMore: return AppTheme.purple
        case .danger: return AppTheme.danger
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(spacing: 8) {
                Text(result.timing.rawValue)
                    .font(.system(size: 26, weight: .black))
                    .foregroundColor(timingColor)
                    .shadow(color: timingColor.opacity(0.45), radius: 12)
                Text(input.goal.description)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity)
            .padding(18)
            .background(RoundedRectangle(cornerRadius: 12).fill(timingColor.opacity(0.12)))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(timingColor.opacity(0.55), lineWidth: 1))

            if let warningMessage = result.warningMessage {
                ResultBlock(icon: "exclamationmark.triangle.fill", title: "注意ポイント", color: AppTheme.danger, text: warningMessage)
            }

            ResultBlock(icon: "brain.head.profile", title: "\(attachmentStyle.label)への攻略", color: AppTheme.purple, text: result.mainTip)
            ResultBlock(icon: "bolt.heart.fill", title: "警戒サイン", color: AppTheme.warning, text: attachmentStyle.warningSign)

            if !result.subTips.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Label("アドバイス", systemImage: "sparkles")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppTheme.pinkLight)
                    ForEach(result.subTips, id: \.self) { tip in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 8))
                                .foregroundColor(AppTheme.pinkLight)
                                .padding(.top, 5)
                            Text(tip)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppTheme.textPrimary)
                                .lineSpacing(4)
                        }
                    }
                }
                .padding(14)
                .luxuryPanel(cornerRadius: 12)
            }

            let tactics = PsychologyEngine.recommendTactics(for: input, attachmentStyle: attachmentStyle)
            if !tactics.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Label("おすすめ心理テク", systemImage: "lightbulb.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppTheme.gold)
                    ForEach(tactics.prefix(3)) { tactic in
                        MiniTacticCard(tactic: tactic)
                    }
                }
                .padding(14)
                .luxuryPanel(cornerRadius: 12, borderColor: AppTheme.gold.opacity(0.45), glowColor: AppTheme.gold.opacity(0.12))
            }
        }
    }
}

struct ResultBlock: View {
    let icon: String
    let title: String
    let color: Color
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(color)
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)
                .lineSpacing(4)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.10)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.35), lineWidth: 1))
    }
}

struct MiniTacticCard: View {
    let tactic: PsychologyTactic

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(tactic.name)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(AppTheme.gold)
                Spacer()
                RatingStars(value: tactic.effectiveness, size: 8)
            }
            Text(tactic.howTo)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(3)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(AppTheme.gold.opacity(0.08)))
    }
}

struct RatingStars: View {
    let value: Int
    let size: CGFloat

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.system(size: size))
                    .foregroundColor(index < value ? AppTheme.gold : AppTheme.textSecondary.opacity(0.28))
            }
        }
    }
}
