import Foundation

struct H0RIIProject: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let subtitle: String
    let status: String
    let accent: String
    let url: String

    static let samples: [H0RIIProject] = [
        .init(name: "H0RII Labs", subtitle: "Software, infrastructure and product systems", status: "Building", accent: "blue", url: "https://horii.dev"),
        .init(name: "AfterHoursMC", subtitle: "Minecraft network, community and hosting systems", status: "Live", accent: "purple", url: "https://afterhoursmc.gg"),
        .init(name: "HXSecurity", subtitle: "Consent-first security tooling and reports", status: "In progress", accent: "red", url: "https://hxsecurity.net"),
        .init(name: "H0RII Excel", subtitle: "Web spreadsheet app for clean workflows", status: "Beta", accent: "green", url: "https://excel.horii.dev")
    ]
}
