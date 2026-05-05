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
                    VStack(spacing: 6) {
                        Text("ホストクラブ攻略アプリ")
                            .font(.system(size: 28, weight: .black))
                            .foregroundStyle(
                                LinearGradient(colors: [AppTheme.gold, AppTheme.pinkLight, AppTheme.pink],
                                               startPoint: .leading, endPoint: .trailing)
                            )
                            .shadow(color: AppTheme.pink.opacity(0.6), radius: 10)

                        Text("～No.1ホストはあなたの彼氏～")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppTheme.textPink)

                        Text("Host Club Strategy")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(.top, 52)
                    .padding(.bottom, 24)

                    // Tagline
                    VStack(spacing: 4) {
                        ForEach(["あの星みたいな", "トップホストを、", "わたしのものに。"], id: \.self) { line in
                            Text(line)
                                .font(.system(size: 32, weight: .black))
                                .foregroundStyle(
                                    LinearGradient(colors: [AppTheme.textPrimary, AppTheme.pinkLight],
                                                   startPoint: .leading, endPoint: .trailing)
                                )
                                .shadow(color: AppTheme.pink.opacity(0.3), radius: 6)
                        }
                    }
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 36)

                    // Goal selection
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("目標を選んでください")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                            Text("What is your goal?")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.textSecondary)
                        }
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
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("攻略の基本")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary)
                                Text("Basic Strategy")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)

                        HStack(spacing: 12) {
                            QuickTipItem(icon: "brain.head.profile", text: "心理学で\n読む", color: AppTheme.purple, subLabel: "Psychology")
                            QuickTipItem(icon: "timer", text: "タイミング\nを計る", color: AppTheme.pink, subLabel: "Timing")
                            QuickTipItem(icon: "exclamationmark.triangle.fill", text: "痛客を\n避ける", color: AppTheme.gold, subLabel: "Avoid")
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
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : AppTheme.pink)
                    .frame(width: 52, height: 52)
                    .background(
                        Circle()
                            .fill(isSelected ? AppTheme.pink : AppTheme.card)
                            .overlay(Circle().stroke(AppTheme.pink.opacity(0.5), lineWidth: 1.5))
                    )
                    .shadow(color: isSelected ? AppTheme.pinkGlow : .clear, radius: 10)

                VStack(alignment: .leading, spacing: 5) {
                    Text(goal.title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(isSelected ? AppTheme.pink : AppTheme.textPrimary)
                    Text(goal.titleEN)
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark" : "chevron.right")
                    .foregroundColor(isSelected ? AppTheme.pink : AppTheme.textSecondary.opacity(0.6))
                    .font(.system(size: isSelected ? 16 : 14, weight: isSelected ? .bold : .regular))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AppTheme.pink.opacity(0.10) : AppTheme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? AppTheme.pink : AppTheme.cardBorder, lineWidth: isSelected ? 1.5 : 1)
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
    let subLabel: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(AppTheme.bg)
                        .overlay(Circle().stroke(color.opacity(0.5), lineWidth: 1.5))
                )
                .shadow(color: color.opacity(0.3), radius: 6)
            Text(text)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
                .multilineTextAlignment(.center)
            Text(subLabel)
                .font(.system(size: 10))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.card)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.4), lineWidth: 1))
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
