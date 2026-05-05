import SwiftUI

struct HomeView: View {
    @Binding var selectedGoal: Goal?
    @Binding var selectedTab: Int

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(colors: [AppTheme.bg, AppTheme.bgMid, Color(red: 0.12, green: 0.03, blue: 0.20)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            // Stars background
            StarsBackground()

            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Text("ホストクラブ攻略アプリ")
                            .font(.system(size: 22, weight: .black))
                            .foregroundStyle(
                                LinearGradient(colors: [AppTheme.pinkLight, AppTheme.pink, AppTheme.purple],
                                               startPoint: .leading, endPoint: .trailing)
                            )
                            .shadow(color: AppTheme.pink.opacity(0.6), radius: 8)

                        Text("～No.1ホストはあなたの彼氏～")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(AppTheme.textPink)

                        Text("Host Club Strategy")
                            .font(.system(size: 11))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(.top, 48)
                    .padding(.bottom, 32)

                    // Tagline
                    Text("あの星みたいなトップホストを、\nわたしのものに。")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 36)

                    // Goal selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("目標を選んでください")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppTheme.textSecondary)
                            .padding(.horizontal, 20)

                        Text("What is your goal?")
                            .font(.system(size: 11))
                            .foregroundColor(AppTheme.textSecondary.opacity(0.6))
                            .padding(.horizontal, 20)

                        ForEach(Goal.allCases) { goal in
                            GoalCard(goal: goal, isSelected: selectedGoal == goal) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedGoal = goal
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    selectedTab = 1
                                }
                            }
                        }
                    }
                    .padding(.bottom, 40)

                    // Quick tips
                    VStack(spacing: 16) {
                        Divider().background(AppTheme.cardBorder)

                        Text("攻略の基本")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppTheme.textSecondary)

                        HStack(spacing: 12) {
                            QuickTipItem(icon: "brain.head.profile", text: "心理学で\n読む", color: AppTheme.purple)
                            QuickTipItem(icon: "timer", text: "タイミング\nを計る", color: AppTheme.pink)
                            QuickTipItem(icon: "exclamationmark.triangle.fill", text: "痛客を\n避ける", color: AppTheme.gold)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct GoalCard: View {
    let goal: Goal
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: goal.icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? AppTheme.bg : AppTheme.pink)
                    .frame(width: 48, height: 48)
                    .background(isSelected ? AppTheme.pink : AppTheme.card)
                    .clipShape(Circle())
                    .shadow(color: isSelected ? AppTheme.pinkGlow : .clear, radius: 8)

                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isSelected ? AppTheme.pink : AppTheme.textPrimary)
                    Text(goal.titleEN)
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textSecondary)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "chevron.right")
                    .foregroundColor(isSelected ? AppTheme.pink : AppTheme.textSecondary)
                    .font(.system(size: 16))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AppTheme.pink.opacity(0.12) : AppTheme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? AppTheme.pink.opacity(0.6) : AppTheme.cardBorder, lineWidth: 1)
                    )
            )
            .padding(.horizontal, 16)
        }
        .buttonStyle(.plain)
    }
}

struct QuickTipItem: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
            Text(text)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.card)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.3), lineWidth: 1))
        )
    }
}

struct StarsBackground: View {
    let stars: [(CGFloat, CGFloat, CGFloat)] = (0..<60).map { _ in
        (CGFloat.random(in: 0...1), CGFloat.random(in: 0...1), CGFloat.random(in: 0.3...1.0))
    }

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<stars.count, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(stars[i].2 * 0.5))
                    .frame(width: 2, height: 2)
                    .position(x: stars[i].0 * geo.size.width, y: stars[i].1 * geo.size.height)
            }
        }
        .ignoresSafeArea()
    }
}
