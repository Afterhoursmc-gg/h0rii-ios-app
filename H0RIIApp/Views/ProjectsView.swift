import SwiftUI

struct ProjectsView: View {
    let projects = H0RIIProject.samples

    var body: some View {
        NavigationStack {
            ZStack {
                H0RIIBackground()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Projects")
                            .font(.largeTitle.bold())
                        Text("Everything important grouped into one native iOS interface.")
                            .foregroundStyle(.secondary)

                        ForEach(projects) { project in
                            Link(destination: URL(string: project.url)!) {
                                ProjectRow(project: project)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Projects")
        }
    }
}

struct ProjectRow: View {
    let project: H0RIIProject
    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 16)
                .fill(project.color.opacity(0.85))
                .frame(width: 58, height: 58)
                .overlay(Image(systemName: project.icon).font(.title2.bold()).foregroundStyle(.white))
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text(project.name).font(.headline).foregroundStyle(.white)
                    Spacer()
                    Text(project.metric).font(.caption.bold()).foregroundStyle(project.color)
                }
                Text(project.subtitle).font(.subheadline).foregroundStyle(.secondary)
                Text(project.status).font(.caption.bold()).foregroundStyle(project.color)
            }
            Image(systemName: "chevron.right").foregroundStyle(.secondary)
        }
        .padding(16)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(.white.opacity(0.08)))
    }
}

#Preview { ProjectsView() }
