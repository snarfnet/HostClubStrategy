import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var selectedGoal: Goal?
    @State private var strategyInput = StrategyInput()

    private let tabs: [(icon: String, label: String)] = [
        ("house.fill", "ホーム"),
        ("heart.text.square.fill", "攻略診断"),
        ("brain.head.profile", "心理学"),
        ("shield.lefthalf.filled", "危険度")
    ]

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

            VStack(spacing: 8) {
                BannerAdView()
                    .frame(height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 18)

                HStack(spacing: 0) {
                    ForEach(tabs.indices, id: \.self) { index in
                        TabBarItem(
                            icon: tabs[index].icon,
                            label: tabs[index].label,
                            isSelected: selectedTab == index
                        ) {
                            if index == 1, let selectedGoal {
                                strategyInput.goal = selectedGoal
                            }
                            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                                selectedTab = index
                            }
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 24)
                .padding(.horizontal, 10)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [AppTheme.pink.opacity(0.45), .clear, AppTheme.purple.opacity(0.35)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 1),
                            alignment: .top
                        )
                )
            }
        }
        .onChange(of: selectedGoal) { _, newGoal in
            if let newGoal {
                strategyInput.goal = newGoal
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 5) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppTheme.pink.opacity(0.26))
                            .frame(width: 42, height: 42)
                            .shadow(color: AppTheme.pinkGlow, radius: 14)
                    }
                    Image(systemName: icon)
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundStyle(isSelected ? AppTheme.titleGradient : LinearGradient(colors: [AppTheme.textSecondary], startPoint: .top, endPoint: .bottom))
                }
                .frame(height: 34)

                Text(label)
                    .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? AppTheme.pinkLight : AppTheme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
