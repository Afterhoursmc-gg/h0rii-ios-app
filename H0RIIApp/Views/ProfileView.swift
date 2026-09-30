import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 18) {
                        Circle()
                            .fill(LinearGradient(colors: [.white, .gray], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 92, height: 92)
                            .overlay(Text("H").font(.system(size: 44, weight: .black)).foregroundStyle(.black))
                        Text("Jhonatan Wik")
                            .font(.largeTitle.bold())
                        Text("H0RII / Horii")
                            .foregroundStyle(.secondary)
                        Text("Norwegian digital creator, developer and entrepreneur building software, Minecraft infrastructure, SaaS products and digital systems.")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        Link("Open horii.dev", destination: URL(string: "https://horii.dev/jhonatan-wik")!)
                            .font(.headline)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 13)
                            .background(Color.white, in: Capsule())
                            .foregroundStyle(.black)
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview { ProfileView() }
