import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                H0RIIBackground()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        hero
                        stats
                        quickActions
                        SectionTitle("Live overview")
                        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 12) {
                            ForEach(H0RIIService.live) { service in
                                ServiceMiniCard(service: service)
                            }
                        }
                        SectionTitle("Latest")
                        ForEach(H0RIIUpdate.feed) { item in
                            ActivityCard(title: item.title, text: item.body, symbol: item.symbol, trailing: item.time)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("H0RII")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("H0RII")
                        .font(.system(size: 52, weight: .black, design: .rounded))
                    Text("Command center")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.78))
                }
                Spacer()
                Image(systemName: "bolt.circle.fill")
                    .font(.system(size: 40))
                    .symbolRenderingMode(.hierarchical)
            }

            Text("A native iOS home for Jhonatan Wik / H0RII projects, live links, ops status and product updates.")
                .foregroundStyle(.secondary)
                .font(.title3)
                .fixedSize(horizontal: false, vertical: true)

            HStack {
                Label("Native SwiftUI", systemImage: "swift")
                Spacer()
                Label("Ready for Xcode", systemImage: "hammer.fill")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white.opacity(0.75))
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(.white.opacity(0.12)))
    }

    private var stats: some View {
        HStack(spacing: 12) {
            StatPill(value: "4", label: "Projects")
            StatPill(value: "Live", label: "Web")
            StatPill(value: "iOS", label: "Native")
        }
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle("Quick actions")
            HStack(spacing: 12) {
                QuickAction(title: "Open H0RII", icon: "safari.fill", url: "https://horii.dev")
                QuickAction(title: "AfterHours", icon: "gamecontroller.fill", url: "https://afterhoursmc.gg")
            }
            HStack(spacing: 12) {
                QuickAction(title: "HXSecurity", icon: "shield.fill", url: "https://hxsecurity.net")
                QuickAction(title: "Excel", icon: "tablecells.fill", url: "https://excel.horii.dev")
            }
        }
    }
}

struct StatusView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                H0RIIBackground()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Status")
                            .font(.largeTitle.bold())
                        Text("Local status snapshot for H0RII systems. Later this can connect to status.horii.dev APIs.")
                            .foregroundStyle(.secondary)
                        ForEach(H0RIIService.live) { service in
                            StatusRow(service: service)
                        }
                        ActivityCard(title: "Next upgrade", text: "Wire this tab to a real public status endpoint with uptime, services and incidents.", symbol: "antenna.radiowaves.left.and.right", trailing: "API")
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Status")
        }
    }
}

struct H0RIIBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, Color(red: 0.035, green: 0.035, blue: 0.07)], startPoint: .top, endPoint: .bottom)
            Circle().fill(.blue.opacity(0.15)).blur(radius: 60).offset(x: 130, y: -260)
            Circle().fill(.purple.opacity(0.12)).blur(radius: 70).offset(x: -160, y: 260)
        }
        .ignoresSafeArea()
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
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.08)))
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

struct ServiceMiniCard: View {
    let service: H0RIIService
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: service.symbol)
                .font(.title2)
                .foregroundStyle(service.tint)
            Text(service.name).font(.headline)
            Text(service.value).font(.caption.bold()).foregroundStyle(service.tint)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 20))
    }
}

struct StatusRow: View {
    let service: H0RIIService
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: service.symbol)
                .font(.title3)
                .foregroundStyle(service.tint)
                .frame(width: 42, height: 42)
                .background(service.tint.opacity(0.14), in: Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text(service.name).font(.headline)
                Text(service.detail).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Text(service.value)
                .font(.caption.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(service.tint.opacity(0.16), in: Capsule())
                .foregroundStyle(service.tint)
        }
        .padding(16)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 22))
    }
}

struct ActivityCard: View {
    let title: String
    let text: String
    let symbol: String
    var trailing: String? = nil

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: symbol).font(.title2).foregroundStyle(.white)
                .frame(width: 44, height: 44).background(Color.white.opacity(0.12), in: Circle())
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title).font(.headline)
                    Spacer()
                    if let trailing {
                        Text(trailing).font(.caption.bold()).foregroundStyle(.secondary)
                    }
                }
                Text(text).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 22))
    }
}

#Preview { DashboardView() }
#Preview { StatusView() }
