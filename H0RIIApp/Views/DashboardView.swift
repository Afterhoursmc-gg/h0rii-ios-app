import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.black, Color(red: 0.04, green: 0.04, blue: 0.08)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        hero
                        stats
                        quickActions
                        SectionTitle("Today")
                        ActivityCard(title: "Build clean products", text: "NOVA, status systems, AfterHoursMC and HXSecurity in one mobile control surface.", symbol: "bolt.fill")
                        ActivityCard(title: "Ship verified", text: "Keep work tied to real URLs, builds and status checks.", symbol: "checkmark.seal.fill")
                    }
                    .padding(20)
                }
            }
            .navigationTitle("H0RII")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("H0RII")
                .font(.system(size: 48, weight: .black, design: .rounded))
            Text("Mobile command center for Jhonatan Wik / H0RII projects.")
                .foregroundStyle(.secondary)
                .font(.title3)
            HStack {
                Label("iOS Native", systemImage: "iphone")
                Spacer()
                Label("SwiftUI", systemImage: "swift")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white.opacity(0.75))
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 28).stroke(.white.opacity(0.12)))
    }

    private var stats: some View {
        HStack(spacing: 12) {
            StatPill(value: "4", label: "Projects")
            StatPill(value: "24/7", label: "Ops")
            StatPill(value: "100%", label: "Owned")
        }
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle("Quick actions")
            HStack(spacing: 12) {
                QuickAction(title: "Open site", icon: "safari.fill", url: "https://horii.dev")
                QuickAction(title: "AfterHours", icon: "gamecontroller.fill", url: "https://afterhoursmc.gg")
            }
        }
    }
}

struct SectionTitle: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View { Text(text).font(.headline).foregroundStyle(.white) }
}

struct StatPill: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.title2.bold())
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
    }
}

struct QuickAction: View {
    let title: String
    let icon: String
    let url: String
    var body: some View {
        Link(destination: URL(string: url)!) {
            Label(title, systemImage: icon)
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 18))
                .foregroundStyle(.black)
        }
    }
}

struct ActivityCard: View {
    let title: String
    let text: String
    let symbol: String
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: symbol).font(.title2).foregroundStyle(.white)
                .frame(width: 44, height: 44).background(Color.white.opacity(0.12), in: Circle())
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.headline)
                Text(text).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 22))
    }
}

#Preview { DashboardView() }
