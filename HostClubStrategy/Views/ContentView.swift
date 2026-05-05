import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var selectedGoal: Goal? = nil
    @State private var strategyInput = StrategyInput()

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(selectedGoal: $selectedGoal, selectedTab: $selectedTab)
                    .tag(0)

                StrategyView(input: $strategyInput)
                    .tag(1)

                PsychologyView()
                    .tag(2)

                DangerCheckView()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom tab bar
            VStack(spacing: 0) {
                Divider()
                    .background(AppTheme.cardBorder)

                HStack(spacing: 0) {
                    ForEach(tabs.indices, id: \.self) { i in
                        TabBarItem(
                            icon: tabs[i].icon,
                            label: tabs[i].label,
                            isSelected: selectedTab == i
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if i == 1, let goal = selectedGoal {
                                    strategyInput.goal = goal
                                }
                                selectedTab = i
                            }
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 28)
                .background(AppTheme.bg)
            }

            // Ad banner above tab bar
            VStack {
                Spacer()
                BannerAdView()
                    .frame(height: 50)
                    .padding(.bottom, 88)
            }
        }
        .onChange(of: selectedGoal) { _, newGoal in
            if let goal = newGoal {
                strategyInput.goal = goal
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    let tabs: [(icon: String, label: String)] = [
        ("house.fill", "ホーム"),
        ("sparkles", "攻略"),
        ("brain.head.profile", "心理学"),
        ("exclamationmark.triangle.fill", "痛客"),
    ]
}

struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppTheme.pink : AppTheme.textSecondary)
                    .shadow(color: isSelected ? AppTheme.pinkGlow : .clear, radius: 4)
                Text(label)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(isSelected ? AppTheme.pink : AppTheme.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
