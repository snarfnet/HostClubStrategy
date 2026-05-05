import SwiftUI

struct StrategyView: View {
    @Binding var input: StrategyInput
    @State private var attachmentStyle: AttachmentStyle = .secure
    @State private var showResult = false
    @State private var result: StrategyResult? = nil

    var body: some View {
        ZStack {
            LinearGradient(colors: [AppTheme.bg, AppTheme.bgMid],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 4) {
                        Text("状況を入力")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(AppTheme.textPrimary)
                        Text("Analyze Your Situation")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(.top, 16)

                    // Goal display
                    if let goal = input.goal as Goal? {
                        GoalBadge(goal: goal)
                    }

                    // Attachment Style
                    InputSection(title: "彼のタイプ（愛着スタイル）", titleEN: "His Attachment Style") {
                        VStack(spacing: 8) {
                            ForEach(AttachmentStyle.allCases) { style in
                                AttachmentStyleRow(style: style, isSelected: attachmentStyle == style) {
                                    attachmentStyle = style
                                }
                            }
                        }
                    }

                    // Host Mood
                    InputSection(title: "今日の彼の態度", titleEN: "His Current Mood") {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                            ForEach(HostMood.allCases) { mood in
                                MoodChip(mood: mood, isSelected: input.hostMood == mood) {
                                    input.hostMood = mood
                                }
                            }
                        }
                    }

                    // Spending
                    InputSection(title: "これまでの使った金額", titleEN: "Total Spending So Far") {
                        VStack(spacing: 6) {
                            ForEach(SpendingLevel.allCases) { level in
                                SelectRow(label: level.label, isSelected: input.spending == level) {
                                    input.spending = level
                                }
                            }
                        }
                    }

                    // Frequency
                    InputSection(title: "来店頻度", titleEN: "Visit Frequency") {
                        VStack(spacing: 6) {
                            ForEach(VisitFrequency.allCases) { freq in
                                SelectRow(label: freq.label, isSelected: input.frequency == freq) {
                                    input.frequency = freq
                                }
                            }
                        }
                    }

                    // Bonus flags
                    InputSection(title: "達成済みの項目", titleEN: "Milestones Reached") {
                        VStack(spacing: 10) {
                            ToggleRow(label: "LINE / SNSの連絡先をゲット済み", isOn: $input.hasLineSNS)
                            ToggleRow(label: "店の外で会ったことがある", isOn: $input.hasPrivateMeet)
                            ToggleRow(label: "名前で呼んでくれる", isOn: $input.calledByName)
                            ToggleRow(label: "プレゼントをもらった", isOn: $input.receivedGift)
                            ToggleRow(label: "競合する他の客がいる", isOn: $input.otherCustomersExist)
                        }
                    }

                    // Analyze button
                    Button {
                        result = PsychologyEngine.analyzeStrategy(input: input, attachmentStyle: attachmentStyle)
                        withAnimation(.spring(response: 0.4)) { showResult = true }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "sparkles")
                            Text("攻略を診断する")
                                .font(.system(size: 17, weight: .bold))
                            Image(systemName: "sparkles")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(colors: [AppTheme.pink, AppTheme.purple],
                                                   startPoint: .leading, endPoint: .trailing)
                                )
                                .shadow(color: AppTheme.pinkGlow, radius: 12)
                        )
                    }
                    .padding(.horizontal, 16)

                    // Result
                    if showResult, let result = result {
                        StrategyResultView(result: result, input: input, attachmentStyle: attachmentStyle)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

struct GoalBadge: View {
    let goal: Goal
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: goal.icon)
            Text("目標：\(goal.title)")
                .font(.system(size: 13, weight: .semibold))
        }
        .foregroundColor(AppTheme.pink)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(AppTheme.pink.opacity(0.15))
                .overlay(Capsule().stroke(AppTheme.pink.opacity(0.4), lineWidth: 1))
        )
    }
}

struct InputSection<Content: View>: View {
    let title: String
    let titleEN: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                Text(titleEN)
                    .font(.system(size: 10))
                    .foregroundColor(AppTheme.textSecondary)
            }
            content
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.card)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppTheme.cardBorder, lineWidth: 1))
        )
    }
}

struct AttachmentStyleRow: View {
    let style: AttachmentStyle
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Circle()
                    .fill(isSelected ? AppTheme.pink : AppTheme.card)
                    .overlay(Circle().stroke(AppTheme.pink.opacity(0.5), lineWidth: 1))
                    .frame(width: 20, height: 20)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(isSelected ? 1 : 0)
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(style.label)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(isSelected ? AppTheme.pink : AppTheme.textPrimary)
                    Text(style.description)
                        .font(.system(size: 10))
                        .foregroundColor(AppTheme.textSecondary)
                        .lineLimit(2)
                }
                Spacer()
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? AppTheme.pink.opacity(0.1) : Color.clear)
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
            VStack(spacing: 6) {
                Image(systemName: mood.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppTheme.pink : AppTheme.textSecondary)
                Text(mood.label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? AppTheme.pink : AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? AppTheme.pink.opacity(0.15) : AppTheme.bgMid)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? AppTheme.pink.opacity(0.6) : Color.clear, lineWidth: 1)
                    )
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
            HStack {
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(isSelected ? AppTheme.pink : AppTheme.textPrimary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppTheme.pink)
                        .font(.system(size: 16))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? AppTheme.pink.opacity(0.12) : AppTheme.bgMid)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ToggleRow: View {
    let label: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(AppTheme.textPrimary)
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(AppTheme.pink)
                .labelsHidden()
        }
    }
}

struct StrategyResultView: View {
    let result: StrategyResult
    let input: StrategyInput
    let attachmentStyle: AttachmentStyle

    var timingColor: Color {
        switch result.timing {
        case .goNow: return AppTheme.pink
        case .goodTiming: return AppTheme.gold
        case .waitMore: return AppTheme.purple
        case .danger: return AppTheme.danger
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Timing banner
            VStack(spacing: 8) {
                Text(result.timing.rawValue)
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(timingColor)
                    .shadow(color: timingColor.opacity(0.5), radius: 8)
                Text(input.goal.description)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(timingColor.opacity(0.12))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(timingColor.opacity(0.4), lineWidth: 1))
            )

            // Warning
            if let warning = result.warningMessage {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(AppTheme.danger)
                    Text(warning)
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textPrimary)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppTheme.danger.opacity(0.1))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.danger.opacity(0.3), lineWidth: 1))
                )
            }

            // Attachment strategy
            VStack(alignment: .leading, spacing: 8) {
                Label("\(attachmentStyle.label)への戦略", systemImage: "brain.head.profile")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(AppTheme.purple)
                Text(result.mainTip)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textPrimary)
                    .lineSpacing(4)
                Text("⚠ \(attachmentStyle.warningSign)")
                    .font(.system(size: 11))
                    .foregroundColor(AppTheme.warning)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppTheme.purple.opacity(0.1))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.purple.opacity(0.3), lineWidth: 1))
            )

            // Tips
            if !result.subTips.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Label("アドバイス", systemImage: "sparkles")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(AppTheme.pink)
                    ForEach(result.subTips, id: \.self) { tip in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 8))
                                .foregroundColor(AppTheme.pink)
                                .padding(.top, 4)
                            Text(tip)
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.textPrimary)
                                .lineSpacing(3)
                        }
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppTheme.card)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.cardBorder, lineWidth: 1))
                )
            }

            // Recommended tactics
            let tactics = PsychologyEngine.recommendTactics(for: input, attachmentStyle: attachmentStyle)
            if !tactics.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Label("おすすめの心理テク", systemImage: "lightbulb.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(AppTheme.gold)
                    ForEach(tactics.prefix(3)) { tactic in
                        MiniTacticCard(tactic: tactic)
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppTheme.card)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.cardBorder, lineWidth: 1))
                )
            }
        }
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
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { i in
                        Image(systemName: "star.fill")
                            .font(.system(size: 7))
                            .foregroundColor(i < tactic.effectiveness ? AppTheme.gold : AppTheme.textSecondary.opacity(0.3))
                    }
                }
            }
            Text(tactic.howTo)
                .font(.system(size: 11))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(3)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(AppTheme.gold.opacity(0.07)))
    }
}
