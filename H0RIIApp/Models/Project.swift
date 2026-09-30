import Foundation
import SwiftUI

struct H0RIIProject: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let subtitle: String
    let status: String
    let accent: String
    let url: String
    let metric: String
    let icon: String

    static let samples: [H0RIIProject] = [
        .init(name: "H0RII Labs", subtitle: "Software, infrastructure and product systems", status: "Building", accent: "blue", url: "https://horii.dev", metric: "Core", icon: "sparkles"),
        .init(name: "AfterHoursMC", subtitle: "Minecraft network, community and hosting systems", status: "Live", accent: "purple", url: "https://afterhoursmc.gg", metric: "SMP", icon: "gamecontroller.fill"),
        .init(name: "HXSecurity", subtitle: "Consent-first security tooling and reports", status: "In progress", accent: "red", url: "https://hxsecurity.net", metric: "Labs", icon: "shield.lefthalf.filled"),
        .init(name: "H0RII Excel", subtitle: "Web spreadsheet app for clean workflows", status: "Beta", accent: "green", url: "https://excel.horii.dev", metric: "PWA", icon: "tablecells.fill")
    ]
}

struct H0RIIService: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let value: String
    let detail: String
    let symbol: String
    let tint: Color

    static let live: [H0RIIService] = [
        .init(name: "Web", value: "Online", detail: "horii.dev and project pages", symbol: "globe", tint: .green),
        .init(name: "Discord", value: "Active", detail: "Bots and community systems", symbol: "message.fill", tint: .blue),
        .init(name: "Minecraft", value: "Live", detail: "AfterHoursMC network", symbol: "cube.fill", tint: .purple),
        .init(name: "Security", value: "Building", detail: "HXSecurity modules", symbol: "lock.shield.fill", tint: .red)
    ]
}

struct H0RIIUpdate: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let body: String
    let time: String
    let symbol: String

    static let feed: [H0RIIUpdate] = [
        .init(title: "iOS app created", body: "Native SwiftUI project ready for Xcode and App Store work.", time: "Now", symbol: "iphone"),
        .init(title: "H0RII web live", body: "Entity pages and project links are available from horii.dev.", time: "Today", symbol: "safari.fill"),
        .init(title: "AfterHoursMC connected", body: "Community, store and server links are grouped in one place.", time: "Today", symbol: "gamecontroller.fill")
    ]
}

extension H0RIIProject {
    var color: Color {
        switch accent {
        case "purple": return .purple
        case "red": return .red
        case "green": return .green
        default: return .blue
        }
    }
}
