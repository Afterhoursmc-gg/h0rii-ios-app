import SwiftUI

struct ProjectsView: View {
    let projects = H0RIIProject.samples

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                List(projects) { project in
                    Link(destination: URL(string: project.url)!) {
                        ProjectRow(project: project)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Projects")
        }
    }
}

struct ProjectRow: View {
    let project: H0RIIProject
    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 14)
                .fill(color.opacity(0.85))
                .frame(width: 54, height: 54)
                .overlay(Text(String(project.name.prefix(1))).font(.title.bold()).foregroundStyle(.white))
            VStack(alignment: .leading, spacing: 6) {
                Text(project.name).font(.headline).foregroundStyle(.white)
                Text(project.subtitle).font(.subheadline).foregroundStyle(.secondary)
                Text(project.status).font(.caption.bold()).foregroundStyle(color)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.secondary)
        }
        .padding(16)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 22))
    }

    private var color: Color {
        switch project.accent {
        case "purple": .purple
        case "red": .red
        case "green": .green
        default: .blue
        }
    }
}

#Preview { ProjectsView() }
