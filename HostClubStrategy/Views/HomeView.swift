import SwiftUI

struct HomeView: View {
    @Binding var selectedGoal: Goal?
    @Binding var selectedTab: Int

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    header
                    goalSection
                    basicsSection
                }
                .padding(.horizontal, 18)
                .padding(.top, 34)
                .padding(.bottom, 150)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 24) {
            HStack {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                HStack(spacing: 8) {
                    Image(systemName: "sparkle")
                        .foregroundStyle(AppTheme.titleGradient)
                    Text("12,345")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    Image(systemName: "plus.circle")
                        .foregroundColor(AppTheme.pinkLight)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Capsule().fill(AppTheme.card))
                .overlay(Capsule().stroke(AppTheme.cardBorder, lineWidth: 1))
            }

            VStack(spacing: 10) {
                Text("ホストクラブ攻略アプリ")
                    .font(.system(size: 29, weight: .black))
                    .foregroundStyle(AppTheme.titleGradient)
                    .shadow(color: AppTheme.pinkGlow, radius: 14)
                    .multilineTextAlignment(.center)

                Text("〜No.1ホストはあなたの彼氏へ〜")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.textPink)

                Text("Host Club Strategy")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
            }

            ZStack(alignment: .bottomLeading) {
                LoungeScene()
                    .frame(height: 228)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppTheme.cardBorder, lineWidth: 1))
                    .shadow(color: AppTheme.pinkGlow, radius: 22)

                VStack(alignment: .leading, spacing: 8) {
                    Text("あの星みたいな")
                    Text("トップホストを、")
                    Text("わたしのものに。")
                }
                .font(.system(size: 25, weight: .black))
                .foregroundStyle(AppTheme.titleGradient)
                .shadow(color: Color.black.opacity(0.7), radius: 8)
                .padding(22)
            }
        }
    }

    private var goalSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle(title: "目標を選んでください", subtitle: "What is your goal?", icon: "crown.fill")

            ForEach(Goal.allCases) { goal in
                GoalCard(goal: goal, isSelected: selectedGoal == goal) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                        selectedGoal = goal
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
                        selectedTab = 1
                    }
                }
            }
        }
    }

    private var basicsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle(title: "攻略の基本", subtitle: "Basic Strategy", icon: "sparkles")

            HStack(spacing: 12) {
                QuickTipItem(icon: "brain.head.profile", text: "心理学で\n読む", color: AppTheme.pink, subLabel: "Psychology")
                QuickTipItem(icon: "timer", text: "タイミング\nを計る", color: AppTheme.gold, subLabel: "Timing")
                QuickTipItem(icon: "shield.lefthalf.filled", text: "痛客を\n避ける", color: AppTheme.purple, subLabel: "Avoid")
            }
        }
    }
}

struct LoungeScene: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.020, green: 0.010, blue: 0.040),
                    Color(red: 0.130, green: 0.020, blue: 0.130),
                    Color(red: 0.030, green: 0.010, blue: 0.050)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            ForEach(0..<5, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.pink.opacity(0.32), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 28, height: CGFloat(92 + index * 10))
                    .offset(x: CGFloat(index * 42) + 36, y: -6)
                    .blur(radius: 0.4)
            }

            Circle()
                .fill(AppTheme.pink.opacity(0.35))
                .frame(width: 92, height: 92)
                .blur(radius: 22)
                .offset(x: 106, y: -50)

            RoundedRectangle(cornerRadius: 60)
                .fill(Color.black.opacity(0.44))
                .frame(width: 210, height: 70)
                .offset(x: 78, y: 66)

            Ellipse()
                .fill(AppTheme.pink.opacity(0.16))
                .frame(width: 110, height: 28)
                .offset(x: 42, y: 72)

            VStack(spacing: 4) {
                Rectangle()
                    .fill(AppTheme.pinkLight.opacity(0.72))
                    .frame(width: 2, height: 38)
                Image(systemName: "sparkle")
                    .font(.system(size: 30))
                    .foregroundColor(AppTheme.pinkLight)
                    .shadow(color: AppTheme.pinkGlow, radius: 14)
            }
            .offset(x: 118, y: -76)
        }
    }
}

struct SectionTitle: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(AppTheme.titleGradient)
                .font(.system(size: 15, weight: .bold))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
            }
            Spacer()
        }
    }
}

struct GoalCard: View {
    let goal: Goal
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(isSelected ? AppTheme.jewelGradient : LinearGradient(colors: [AppTheme.cardElevated], startPoint: .top, endPoint: .bottom))
                        .frame(width: 48, height: 48)
                        .overlay(Circle().stroke(AppTheme.pinkLight.opacity(0.55), lineWidth: 1))
                    Image(systemName: goal.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(isSelected ? .white : AppTheme.pinkLight)
                }
                .shadow(color: isSelected ? AppTheme.pinkGlow : .clear, radius: 14)

                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isSelected ? AppTheme.pinkLight : AppTheme.textPrimary)
                    Text(goal.titleEN)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark" : "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isSelected ? AppTheme.pinkLight : AppTheme.textSecondary)
            }
            .padding(16)
            .luxuryPanel(
                cornerRadius: 12,
                borderColor: isSelected ? AppTheme.pink : AppTheme.cardBorder,
                glowColor: isSelected ? AppTheme.pinkGlow : .clear,
                fill: isSelected ? AppTheme.pink.opacity(0.16) : AppTheme.card
            )
        }
        .buttonStyle(.plain)
    }
}

struct QuickTipItem: View {
    let icon: String
    let text: String
    let color: Color
    let subLabel: String

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.45), lineWidth: 1)
                    .frame(width: 58, height: 58)
                Image(systemName: icon)
                    .font(.system(size: 27, weight: .medium))
                    .foregroundColor(color)
                    .shadow(color: color.opacity(0.5), radius: 8)
            }
            Text(text)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
            Text(subLabel)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .luxuryPanel(cornerRadius: 10, borderColor: color.opacity(0.45), glowColor: color.opacity(0.12))
    }
}
